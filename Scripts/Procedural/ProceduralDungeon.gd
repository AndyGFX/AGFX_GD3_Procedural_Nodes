extends "ProceduralData.gd"

class_name ProceduralDungeon

#ENUMS

enum eSideType {WALL,EXIT}
enum eBuildMode {SPELUNKY,PATH,MAZE}
enum eStartSide {TOP=0,RIGHT=1,BOTTOM=2,LEFT=3,RANDOM=4}
enum eCellType {UNUSED_CELL,LEVEL_CELL,EXTENDED_CELL}
enum eDirections {UP=0,RIGHT=1,DOWN=2,LEFT=3}

#VARS


var buildMode:int = eBuildMode.SPELUNKY
var startSide:int = eStartSide.TOP
var current_cell:Vector2 = Vector2.ZERO
var connectedCells:PoolVector2Array = PoolVector2Array()
var addExtendedCells:bool = false
var extendedCellsProb:float = 0.5
var connectExtendedCells:bool = true
var startCellPos:Vector2 = Vector2.ZERO

class empty_cell:
	var up:int = eSideType.EXIT
	var right:int = eSideType.EXIT
	var down:int = eSideType.EXIT
	var left:int = eSideType.EXIT
	var visited:int = 0
	var cellType:int = eCellType.UNUSED_CELL
	var nextCell:Vector2 = Vector2(0,0)
	var currentCell:Vector2 = Vector2(0,0)
	var prevCell:Vector2 = Vector2(0,0)
	var userData:Dictionary = {}
	
func _init(w:int,h:int,rnd:bool,useed:int):
	
	# max rooms count in X
	self.width = w
	
	# max rooms count in Y
	self.height = h
	
	self.randomSeed = rnd
	self._seed_ = useed
	
	self.Create(empty_cell)
	self.Clean(empty_cell)
	
	self.connectedCells = PoolVector2Array()
	
func Build()->void:
	
	self.done = false
	
	# prepare dungeon cells - PASS #1
	self.GenerateMap_Pass1()
	
	if (self.randomSeed):
		randomize()
		self._seed_ = randi()
	
	seed(self._seed_)	
	
	# build dungeon cells by mode - PASS #2
	match self.buildMode:
		eBuildMode.SPELUNKY:
			self.GenerateMapAsSpelunky()
		eBuildMode.PATH:
			self.GenerateMapAsPath()
		eBuildMode.MAZE:
			self.GenerateMapAsMaze()
	self.done = true

	# add doors to rooms and add link between rooms - PASS #3
	self.GenerateRoomLinksAndDoors()

	# add extended cells on unused cells - PASS #4
	if self.addExtendedCells: self.AddExtenedCells()
	
	# connect extended cells with level cells
	if self.connectExtendedCells: self.ConnectExtendedCells()

func Reset():
	self.current_cell = Vector2.ZERO
	self.connectedCells = PoolVector2Array()
	self.Create(empty_cell)
	self.Clean(empty_cell)
	
func ToString(x,y):
	var _x = x
	var	_y = y
	return "{"+String(self.data[_x][_y].up)+","+String(self.data[_x][_y].right)+","+String(self.data[_x][_y].down)+","+String(self.data[_x][_y].left)+"}"
	
func GenerateMap_Pass1()->void:
	
	# create closed rooms array 
	for x in range(0,self.width):
		for y in range(0,self.height):
						
			self.data[x][y].up = eSideType.WALL
			self.data[x][y].down = eSideType.WALL
			self.data[x][y].left = eSideType.WALL
			self.data[x][y].right = eSideType.WALL
			self.data[x][y].cellType = eCellType.UNUSED_CELL
		pass

func GetStartRoomPosition()->void:
	var cx:int = 0
	var cy:int = 0
	
	match self.startSide:

		eStartSide.TOP:
			cx = 1 + randi() % self.width-1
			cy = 0
			
		eStartSide.RIGHT:
			cx = self.width-1
			cy = randi() % self.height
			
		eStartSide.BOTTOM:
			cx = randi() % self.width
			cy = self.height-1
			
		eStartSide.LEFT:
			cx = 0
			cy = randi() % self.height
			
		eStartSide.RANDOM:
			cx = randi() % self.width
			cy = randi() % self.height
			
	self.current_cell = Vector2(cx,cy)

func IsNextCellUnused(offset:Vector2)->bool:
	var res:bool = false
	
	if self.data[self.current_cell.x+offset.x][self.current_cell.y+offset.y].cellType==eCellType.UNUSED_CELL:
		res = true
	
	return res

func ExistRoomAt(x:int, y:int, x_off:int,y_off:int, current_type:int, conected_type:int)->bool:
	var res:bool = false

	var cx:int  = x + x_off
	var cy:int  = y + y_off

	if self.data[x][y].cellType == current_type:		
		if cx<0:
			return false
		if cy<0:
			return false
		if cx>=self.width:
			return false
		if cy>=self.height:
			return false
		if self.data[cx][cy].cellType == conected_type:
			return true

		
	return res

func GetNextRoom_SpelunkyType_TOP()->void:
	
	var dir:int = 0
	var dir_offset:Vector2 = Vector2.ZERO

	dir = randi() % 5
		
	match dir:
		# RIGHT
		0,1:
			dir_offset = Vector2(1,0)
			if self.current_cell.x+dir_offset.x>=self.width:
				dir_offset = Vector2(0,1)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(0,1)

		# LEFT
		2,3:
			dir_offset = Vector2(-1,0)
			if self.current_cell.x+dir_offset.x<0:
				dir_offset = Vector2(0,1)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(0,1)
			
		#DOWN
		4: 
			dir_offset = Vector2(0,1)
		
	self.current_cell = self.current_cell + dir_offset
		
func GetNextRoom_SpelunkyType_RIGHT()->void:
	
	var dir:int = 0
	var dir_offset:Vector2 = Vector2.ZERO

	dir = randi() % 5
		
	match dir:
		# UP
		0,1:
			dir_offset = Vector2(0,-1)
			if self.current_cell.y+dir_offset.y<0:
				dir_offset = Vector2(-1,0)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(-1,0)
	
		# DOWN
		2,3:
			dir_offset = Vector2(0,1)
			if self.current_cell.y+dir_offset.y>=self.height:
				dir_offset = Vector2(-1,0)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(-1,0)
			
		#LEFT
		4: 
			dir_offset = Vector2(-1,0)
				
	self.current_cell = self.current_cell + dir_offset

func GetNextRoom_SpelunkyType_BOTTOM()->void:

	var dir:int = 0
	var dir_offset:Vector2 = Vector2.ZERO

	dir = randi() % 5
		
	match dir:
		# RIGHT
		0,1:
			dir_offset = Vector2(1,0)
			if self.current_cell.x+dir_offset.x>=self.width:
				dir_offset = Vector2(0,-1)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(0,-1)

		# LEFT
		2,3:
			dir_offset = Vector2(-1,0)
			if self.current_cell.x+dir_offset.x<0:
				dir_offset = Vector2(0,-1)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(0,-1)
			
		#UP
		4: 
			dir_offset = Vector2(0,-1)
				
	self.current_cell = self.current_cell + dir_offset

func GetNextRoom_SpelunkyType_LEFT()->void:

	var dir:int = 0
	var dir_offset:Vector2 = Vector2.ZERO

	dir = randi() % 5
		
	match dir:
		# UP
		0,1:
			dir_offset = Vector2(0,-1)
			if self.current_cell.y+dir_offset.y<0:
				dir_offset = Vector2(1,0)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(1,0)
	
		# DOWN
		2,3:
			dir_offset = Vector2(0,1)
			if self.current_cell.y+dir_offset.y>=self.height:
				dir_offset = Vector2(1,0)
			elif self.IsNextCellUnused(dir_offset)==false:
				dir_offset = Vector2(1,0)
			
		#RIGHT
		4: 
			dir_offset = Vector2(1,0)
				
	self.current_cell = self.current_cell + dir_offset

func GenerateMapAsMaze()->void:
	pass
	
func GenerateRoomLinksAndDoors()->void:

	# START
	var cpos:Vector2 = self.connectedCells[0]
	self.data[cpos.x][cpos.y].prevCell = self.connectedCells[0]
	self.data[cpos.x][cpos.y].nextCell = self.connectedCells[1]

	# PATH
	for i in range(1,self.connectedCells.size()-1):
		cpos = self.connectedCells[i]
		self.data[cpos.x][cpos.y].prevCell = self.connectedCells[i-1]
		self.data[cpos.x][cpos.y].currentCell = cpos
		self.data[cpos.x][cpos.y].nextCell = self.connectedCells[i+1]
		pass
	
	# END

	var ci:int = self.connectedCells.size()
	cpos = self.connectedCells[ci-1]
		
	self.data[cpos.x][cpos.y].prevCell = self.connectedCells[ci-2]
	self.data[cpos.x][cpos.y].nextCell = self.connectedCells[ci-1]

	
	for x in range(0,self.width):
		for y in range(0,self.height):
			
			if self.data[x][y].cellType == eCellType.LEVEL_CELL:

				var prev_room:Vector2 = self.data[x][y].prevCell-Vector2(x,y);
				
				if prev_room==Vector2.LEFT: self.data[x][y].left=true
				if prev_room==Vector2.RIGHT: self.data[x][y].right=true
				if prev_room==Vector2.UP: self.data[x][y].up=true
				if prev_room==Vector2.DOWN: self.data[x][y].down=true
				
				var next_room:Vector2 = self.data[x][y].nextCell-Vector2(x,y);

				if next_room==Vector2.LEFT: self.data[x][y].left=true
				if next_room==Vector2.RIGHT: self.data[x][y].right=true
				if next_room==Vector2.UP: self.data[x][y].up=true
				if next_room==Vector2.DOWN: self.data[x][y].down=true

func ConnectExtendedCells()->void:
	for x in range(0,self.width):
		for y in range(0,self.height):
			
				if self.ExistRoomAt(x,y,1,0,eCellType.EXTENDED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].right = true
				if self.ExistRoomAt(x,y,-1,0,eCellType.EXTENDED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].left = true
				if self.ExistRoomAt(x,y,0,1,eCellType.EXTENDED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].down = true
				if self.ExistRoomAt(x,y,0,-1,eCellType.EXTENDED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].up = true
				
	for x in range(0,self.width):
		for y in range(0,self.height):
				
				if self.ExistRoomAt(x,y,1,0,eCellType.LEVEL_CELL ,eCellType.EXTENDED_CELL): self.data[x][y].right = true
				if self.ExistRoomAt(x,y,-1,0,eCellType.LEVEL_CELL ,eCellType.EXTENDED_CELL): self.data[x][y].left = true
				if self.ExistRoomAt(x,y,0,1,eCellType.LEVEL_CELL ,eCellType.EXTENDED_CELL): self.data[x][y].down = true
				if self.ExistRoomAt(x,y,0,-1,eCellType.LEVEL_CELL ,eCellType.EXTENDED_CELL): self.data[x][y].up = true

func AddExtenedCells()->void:
	for x in range(0,self.width):
		for y in range(0,self.height):
			if randf()<self.extendedCellsProb:
				if self.ExistRoomAt(x,y,1,0,eCellType.UNUSED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].cellType = eCellType.EXTENDED_CELL
				if self.ExistRoomAt(x,y,-1,0,eCellType.UNUSED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].cellType = eCellType.EXTENDED_CELL
				if self.ExistRoomAt(x,y,0,1,eCellType.UNUSED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].cellType = eCellType.EXTENDED_CELL
				if self.ExistRoomAt(x,y,0,-1,eCellType.UNUSED_CELL ,eCellType.LEVEL_CELL): self.data[x][y].cellType = eCellType.EXTENDED_CELL
		pass

func GenerateMapAsSpelunky()->void:
		
	self.GetStartRoomPosition()
	self.connectedCells.append(self.current_cell)
	self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
	self.startCellPos = self.current_cell

	# from TOP -> DOWN
	if  self.startSide == eStartSide.TOP:
		while self.current_cell.y<self.height-1:
			self.GetNextRoom_SpelunkyType_TOP()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL			
			self.connectedCells.append(self.current_cell)
	
	# from RIGHT -> LEFT
	if  self.startSide == eStartSide.RIGHT:
		while self.current_cell.x>0:
			self.GetNextRoom_SpelunkyType_RIGHT()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL			
			self.connectedCells.append(self.current_cell)

	# from BOTTOM -> UP
	if  self.startSide == eStartSide.BOTTOM:
		while self.current_cell.y>0:
			self.GetNextRoom_SpelunkyType_BOTTOM()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
			self.connectedCells.append(self.current_cell)

	# from LEFT -> RIGHT
	if  self.startSide == eStartSide.LEFT:
		while self.current_cell.x<self.width-1:
			self.GetNextRoom_SpelunkyType_LEFT()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
			self.connectedCells.append(self.current_cell)

	if  self.startSide == eStartSide.RANDOM:
		
		# RND->BOTTOM
		self.current_cell = self.startCellPos
		while self.current_cell.y<self.height-1:
			self.GetNextRoom_SpelunkyType_TOP()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL			
			self.connectedCells.append(self.current_cell)
		


		pass

	pass
		
func GenerateMapAsPath()->void:
	pass

func DumpData()->void:

	for i in range(0,self.connectedCells.size()):
		print(String(i)+" : "+String(self.connectedCells[i]))
