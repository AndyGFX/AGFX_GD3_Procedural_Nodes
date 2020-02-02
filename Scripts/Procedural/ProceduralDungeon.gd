extends "ProceduralData.gd"

class_name ProceduralDungeon

#ENUMS

enum eSideType {WALL,EXIT}
enum eBuildMode {SPELUNKY,PATH,MAZE}
enum eStartSide {TOP,RIGHT,BOTTOM,LEFT}

#VARS

var origin_bottomleft:bool = false
var buildMode:int = eBuildMode.SPELUNKY
var startSide:int = eStartSide.TOP

# 0 = no way => WALL
# 1 =  exit/door/corridor

class empty_cell:
	var up:int = eSideType.EXIT
	var right:int = eSideType.EXIT
	var down:int = eSideType.EXIT
	var left:int = eSideType.EXIT
	var visited:int = 0
	var nextCell:Vector2 = Vector2(-1,-1)
	var userData:Dictionary = {}
	
func _init(w:int,h:int,rnd:bool,useed:int):

	# max rooms count in X
	self.width = w
	
	# max rooms count in Y
	self.height = h
	
	self.Create(empty_cell)
	self.Clean(empty_cell)
	
func Build()->void:
	self.done = false
	
	# prepare dungeon cells
	self.GenerateMap_Pass1()
	
	# build dungeon cells by mode
	match self.buildMode:
		eBuildMode.SPELUNKY:
			self.GenerateMapAsSpelunky()
		eBuildMode.PATH:
			self.GenerateMapAsPath()
		eBuildMode.MAZE:
			self.GenerateMapAsMaze()
	self.done = true

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
	pass
	
func GetCell(x:int,y:int)->empty_cell:
	var _y = self.height - y -1
	return self.data[x][_y]
	pass
	
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
			
		pass


func GenerateMapAsMaze()->void:
	pass
	
func GenerateMapAsSpelunky()->void:
	pass
	
func GenerateMapAsPath()->void:
	pass
