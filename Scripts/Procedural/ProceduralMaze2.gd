extends "ProceduralData.gd"

class_name ProceduralMaze2

var invert = false;

var EMPTY:bool = false
var WALL:bool = true

var g_intDepth:int = 0 

class empty_cell:
	var value:int = 0
	

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
	
	pass

func InvertMazeMap():
	for x in range(0,self.width):		
		for y in range(0,self.height):
			
			self.data[x][y].left = !self.data[x][y].left
			self.data[x][y].right = !self.data[x][y].right
			self.data[x][y].up = !self.data[x][y].up
			self.data[x][y].down = !self.data[x][y].down

func DigMaze(Maze, x:int, y:int):
	
	var newx:int = 0; 
	var newy:int = 0; 
 
	g_intDepth = g_intDepth + 1; 
 
	Maze[x][y] = 1
	var intCount:int = self.ValidCount(Maze, x, y)
	
	while (intCount > 0):
		match (randi()%4):
			0:
				if (self.ValidMove(Maze, x,y-2) > 0):
					Maze[x][y-1] = 1
					self.DigMaze(Maze, x,y-2) 
			1:
				if (self.ValidMove(Maze, x+2,y) > 0):  
					Maze[x+1][y] = 1; 
					self.DigMaze (Maze, x+2,y)

			2:
				if (self.ValidMove(Maze, x,y+2) > 0): 
					Maze[x][y+1] = 1
					self.DigMaze (Maze, x,y+2)
			3:
				if (ValidMove(Maze, x-2,y) > 0): 
					Maze[x-1][y] = 1 
					self.DigMaze (Maze, x-2,y)

		intCount = self.ValidCount(Maze, x, y)
		pass
	 g_intDepth = g_intDepth - 1
	pass


func ValidMove(Maze, x:int, y:int):
	var intResult:int = 0; 
	if (x>=0 and x<self.width and y>=0 and y<self.height and Maze[x][y] == 0):
		intResult = 1
  return intResult; 

func ValidCount(Maze, x:int, y:int):
	var intResult:int = 0
 
	intResult += self.ValidMove(Maze, x,y-2); 
	intResult += self.ValidMove(Maze, x+2,y); 
	intResult += self.ValidMove(Maze, x,y+2); 
	intResult += self.ValidMove(Maze, x-2,y); 
 
	return intResult; 
