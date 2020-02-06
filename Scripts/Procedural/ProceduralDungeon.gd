extends "ProceduralData.gd"

class_name ProceduralDungeon

#ENUMS

enum eSideType {WALL,EXIT}
enum eBuildMode {SPELUNKY,PATH,MAZE}
enum eStartSide {TOP=0,RIGHT=1,BOTTOM=2,LEFT=3,RANDOM=4}
enum eCellType {UNUSED_CELL,LEVEL_CELL,EXTENDED_CELL}
enum eDirections {UP=0,RIGHT=1,DOWN=2,LEFT=3}
#VARS

var origin_bottomleft:bool = false
var buildMode:int = eBuildMode.SPELUNKY
var startSide:int = eStartSide.TOP
var current_cell:Vector2 = Vector2.ZERO
var connectedCells:PoolVector2Array = PoolVector2Array()

class empty_cell:
	var up:int = eSideType.EXIT
	var right:int = eSideType.EXIT
	var down:int = eSideType.EXIT
	var left:int = eSideType.EXIT
	var visited:int = 0
	var cellType:int = eCellType.UNUSED_CELL
	var nextCell:Vector2 = Vector2(-1,-1)
	var prevCell:Vector2 = Vector2(-1,-1)
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
	
	self.connectedCells.empty()
	
func Build()->void:
	self.done = false
	
	# prepare dungeon cells
	self.GenerateMap_Pass1()
	
	if (self.randomSeed):
		randomize()
		self._seed_ = randi()
	
	seed(self._seed_)	
	
	# build dungeon cells by mode
	match self.buildMode:
		eBuildMode.SPELUNKY:
			self.GenerateMapAsSpelunky()
		eBuildMode.PATH:
			self.GenerateMapAsPath()
		eBuildMode.MAZE:
			self.GenerateMapAsMaze()
	self.done = true


func Reset():
	self.current_cell = Vector2.ZERO
	self.connectedCells = PoolVector2Array()
	self.Create(empty_cell)
	self.Clean(empty_cell)
	
func ToString(x,y):
	var _x = x
	var _y = 0
	if self.origin_bottomleft:
		_y = self.height-y-1
	else:
		_y = y
	return "{"+String(self.data[_x][_y].up)+","+String(self.data[_x][_y].right)+","+String(self.data[_x][_y].down)+","+String(self.data[_x][_y].left)+"}"

	
func GenerateMap_Pass1()->void:
	
	var mx = 0
	var my = 0
	
	# create closed rooms array 
	for x in range(0,self.width):
		for y in range(0,self.height):
			
			mx = ((x*2) + 1)			
			my = ((y*2) + 1)  # origin bottom/left
	
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

func GetNextRoom_SpelunkyType()->void:
	
	var dir:int = 0
	var dir_offset:Vector2 = Vector2.ZERO
	# ---------------------------------------------------------------- TOP->DOWN
	if  self.startSide == eStartSide.TOP:
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

	# ------------------------------------------------------------ RIGHT -> LEFT
	if  self.startSide == eStartSide.RIGHT:
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
	
func GenerateMapAsMaze()->void:
	pass
	
	
func GenerateMapAsSpelunky()->void:
	var max_rooms:int = self.width*self.height
	
	self.GetStartRoomPosition()
	self.connectedCells.append(self.current_cell)
	self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
	
	if  self.startSide == eStartSide.TOP:
		while self.current_cell.y<self.height-1:
			self.GetNextRoom_SpelunkyType()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
			self.connectedCells.append(self.current_cell)
	
	if  self.startSide == eStartSide.RIGHT:
		while self.current_cell.x>0:
			self.GetNextRoom_SpelunkyType()
			self.data[self.current_cell.x][self.current_cell.y].cellType=eCellType.LEVEL_CELL
			self.connectedCells.append(self.current_cell)
	
	pass
		
func GenerateMapAsPath()->void:
	pass

func DumpData()->void:

	for i in range(0,self.connectedCells.size()):
		print(String(i)+" : "+String(self.connectedCells[i]))
