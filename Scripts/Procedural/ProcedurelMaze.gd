extends "ProceduralData.gd"

export var invert = false;

var EMPTY = 0
var WALL = 1

class empty_cell:
	var left = 0
	var right = 0
	var up = 0
	var down = 0
	var visited = 0

func _ready():
	self.Create(empty_cell)
	
	self.data[0][0].left=1
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
				self.data[x][y].down = WALL
				self.data[x][y+1].up = WALL
			elif (x==self.width):
				self.data[x][y].right = WALL
				self.data[x+1][y].left = WALL
			elif (floor(rand_range(0,2))==0):
				self.data[x][y].down = WALL
				self.data[x][y+1].up = WALL
			else:
				self.data[x][y].right = WALL
				self.data[x+1][y].left = WALL

#	for y in range(1,self.width):  	#i
#		for x in range(1,self.height): 	#j
#			if ((y==self.height) and (x==self.width)):
#				pass
#			elif (y==self.height):
#				self.data[y-1][x-1].right = 1
#				self.data[y-1][x].left = 1
#			elif (x==self.width):
#				self.data[y-1][x-1].down = 1
#				self.data[y][x-1].up = 1
#			elif (floor(rand_range(0,2))==0):
#				self.data[y-1][x-1].right = 1
#				self.data[y-1][x].left = 1
#			else:
#				self.data[y-1][x-1].down = 1
#				self.data[y][x-1].up = 1
				



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
