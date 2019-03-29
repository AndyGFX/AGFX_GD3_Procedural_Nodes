extends "ProceduralData.gd"

class_name ProceduralMaze

var invert = false;

var EMPTY:bool = false
var WALL:bool = true

class empty_cell:
	var left:bool = 0
	var right:bool = 0
	var up:bool = 0
	var down:bool = 0
	var visited:bool = 0

func _init(w:int,h:int):
	
	self.width = w
	self.height = h	
	self.Create(empty_cell)
	self.Clean(empty_cell)
	pass
	

func Build():	
	self.done = false
	self.GenerateMap()
	if self.invert: self.InvertMazeMap()
	self.done = true
	
func GenerateMap():
	
	for x in range(0,self.width-1):
		for y in range(0,self.height-1):
			if (y==self.height) and (x==self.width):
				# nothing
				pass
			elif (y==self.height):
				self.data[x][y].down = WALL
				self.data[x][y+1].up = WALL
			elif (x==self.width):
				self.data[x][y].right = WALL
				self.data[x+1][y].left = WALL
			elif (floor(rand_range(0,3))==0):
				self.data[x][y].down = WALL
				self.data[x][y+1].up = WALL
			else:
				self.data[x][y].right = WALL
				self.data[x+1][y].left = WALL


func InvertMazeMap():
	for x in range(0,self.width):		
		for y in range(0,self.height):
			
			self.data[x][y].left = !self.data[x][y].left
			self.data[x][y].right = !self.data[x][y].right
			self.data[x][y].up = !self.data[x][y].up
			self.data[x][y].down = !self.data[x][y].down
			