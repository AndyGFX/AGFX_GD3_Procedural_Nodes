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


class empty_cell:
	var up:int = eSideType.EXIT
	var right:int = eSideType.EXIT
	var down:int = eSideType.EXIT
	var left:int = eSideType.EXIT
	var visited:int = 0
	var cellType:int = 0
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
	self.Create(empty_cell)
	self.Clean(empty_cell)

func IsUp(x:int,y:int,sideType:int)->bool:
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].up==sideType: res = true
	else:
		if self.data[x][y].up==sideType: res = true
	return res
	
func IsRight(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].right==sideType: res = true
	else:
		if self.data[x][y].right==sideType: res = true
	return res
	
func IsDown(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].down==sideType: res = true
	else:
		if self.data[x][y].down==sideType: res = true
	return res

func IsLeft(x:int,y:int,sideType:int):
	var res=false
	if self.origin_bottomleft:
		if self.data[x][self.height-y-1].left==sideType: res = true
	else:
		if self.data[x][y].left==sideType: res = true
	return res
	
func ToString(x,y):
	var _x = x
	var _y = 0
	if self.origin_bottomleft:
		_y = self.height-y-1
	else:
		_y = y
	return "{"+String(self.data[_x][_y].up)+","+String(self.data[_x][_y].right)+","+String(self.data[_x][_y].down)+","+String(self.data[_x][_y].left)+"}"
	
func GetCell(x:int,y:int)->empty_cell:
	var _y = self.height - y -1
	return self.data[x][_y]

	
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
			cx = randi() % self.width
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

func GetNextRoomPosition()->void:
	
	var dir:int = 0
	
	# ---------------------------------------------------------------------- TOP
	dir = randi() % 3
	
	match dir:
		0:
			if self.current_cell.x<self.width-1 && self.data[self.current_cell.x+1][self.current_cell.y].cellType==eCellType.UNUSED_CELL:
				self.current_cell.x=self.current_cell.x+1
			else:
				dir = 2
		1:
			if self.current_cell.x>0 && self.data[self.current_cell.x-1][self.current_cell.y].cellType==eCellType.UNUSED_CELL:
				self.current_cell.x=self.current_cell.x-1
			else:
				dir = 2
		2: 
			if self.current_cell.y<self.height:
				self.current_cell.y=self.current_cell.y+1
		
	
func GenerateMapAsMaze()->void:
	pass
	
	
func GenerateMapAsSpelunky()->void:
	var max_rooms:int = self.width*self.height
	
	self.GetStartRoomPosition()
	print(current_cell)
	self.data[self.current_cell.x][self.current_cell.y].cellType = eCellType.LEVEL_CELL

	# link to previous cell is SAME on start CELL
	self.data[self.current_cell.x][self.current_cell.y].prevCell = Vector2(self.current_cell.x,self.current_cell.y)
	
	
	#cell_pos = self.GetNextRoomPosition(cell_pos)
	#print(cell_pos)
	
	
	for i in range(0,max_rooms):
		if self.current_cell.y<self.height-1:
			
			#save current cell position for set link from prev cell to next
			var prev:Vector2 = Vector2(self.current_cell.x,self.current_cell.y)
			self.GetNextRoomPosition()
			self.data[prev.x][prev.y].nextCell = Vector2(self.current_cell.x,self.current_cell.y)
			self.data[self.current_cell.x][self.current_cell.y].cellType = eCellType.LEVEL_CELL
			self.data[self.current_cell.x][self.current_cell.y].prevCell = prev
	
	pass
		
func GenerateMapAsPath()->void:
	pass

func DumpData()->void:
	for x in range(0,self.width):
		for y in range(0,self.height):
			if self.data[x][y].cellType==eCellType.LEVEL_CELL:
				
				var info:String = "prev: "+String(self.data[x][y].prevCell)+" | curr: "+String(x)+","+String(y)+" next: "+String(self.data[x][y].nextCell)
				print(info)
		pass
