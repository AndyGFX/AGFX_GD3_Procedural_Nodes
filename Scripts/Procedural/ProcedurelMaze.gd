extends "ProceduralData.gd"

export var invert = false;

var EMPTY = 0
var WALL = 1

var empty_cell = {
	"left":0,
	"right":0,
	"up":0,
	"down":0,
	"visited":0
	}

func _ready():
	self.Create(empty_cell)
	self.Clean(empty_cell)
	self.Build()
	pass
	

func Build():
	print("Build")
	self.done = false
	self.GenerateMap()
	if self.invert: self.InvertMazeMap()
	self.done = true
	
func GenerateMap():
	
	for x in range(self.width-1):
		for y in range(self.height-1):
			if (y==self.height) and (x==self.width):
				# nothing
				pass
			elif (y==self.height):
				self.data[x][y].right = WALL
				self.data[x][y+1].right = WALL
			elif (x==self.width):
				self.data[x][y].right = WALL
				self.data[x+1][y].right = WALL
			elif (floor(rand_range(0,2))==0):
				self.data[x][y].right = WALL
				self.data[x][y+1].left = WALL
			else:
				self.data[x][y].down = WALL
				self.data[x+1][y].up = WALL

func InvertMazeMap():
	for x in range(self.width):		
		for y in range(self.height):
			
			if self.data[x][y].left == 0:
				self.data[x][y].left = 1
			elif self.data[x][y].left == 1:
				self.data[x][y].left = 0
				
			if self.data[x][y].right == 0:
				self.data[x][y].right = 1
			elif self.data[x][y].right == 1:
				self.data[x][y].right = 0
				
			if self.data[x][y].up == 0:
				self.data[x][y].up = 1
			elif self.data[x][y].up == 1:
				self.data[x][y].up = 0
				
			if self.data[x][y].down == 0:
				self.data[x][y].down = 1
			elif self.data[x][y].down == 1:
				self.data[x][y].down = 0
