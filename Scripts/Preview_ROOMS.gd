extends Node2D


export var room_count:Vector2 = Vector2(5,5)
export var userSeed:int = 2019
export var RandomSeed:bool = false
var proceduralData
var paint_maze:Image
var paint_rooms:Image


func _ready():
	
	# build rooms
	self.proceduralData = ProceduralRooms.new(self.room_count.x,self.room_count.y,self.RandomSeed,self.userSeed)	
	self.proceduralData.Build()
	
	# preview rooms as texture
	self.paint_maze = Image.new()	
	self.paint_maze.create(self.proceduralData.width*2+1,self.proceduralData.height*2+1,false,Image.FORMAT_RGBA8)	
	
	self.paint_rooms = Image.new()	
	self.paint_rooms.create(self.proceduralData.width*4,self.proceduralData.height*4,false,Image.FORMAT_RGBA8)	

	

func _draw():

	
	PreviewMaze()
	
	
	var itex1 = ImageTexture.new()    	
	itex1.create_from_image(self.paint_maze,0)
	$Preview_MAZE.set_texture(itex1)
	
	PreviewRooms()
	var itex2 = ImageTexture.new()    	
	itex2.create_from_image(self.paint_rooms,0)
	$Preview_ROOMS.set_texture(itex2)
	
func PreviewMaze():

	for x in range(0,self.proceduralData.maze.width):
		for y in range(0,self.proceduralData.maze.height):
			self.paint_maze.lock()
			if (self.proceduralData.maze.data[x][y].value==1):
				self.paint_maze.set_pixel(x,y,Color(1,1,1,1))
			else:
				self.paint_maze.set_pixel(x,y,Color(0,0,0,1))
			self.paint_maze.unlock()
	
	pass


func PreviewRooms():
	
			
	# draw walls
	for x in range(0,self.proceduralData.width):
		for y in range(0,self.proceduralData.height):
			self._DrawCell(x,y)

	for y in range(0,self.proceduralData.height):
		for x in range(0,self.proceduralData.width):
		
			if (self.proceduralData.data[x][y].left==1): _DrawDoor(x,y,0,1)
			if (self.proceduralData.data[x][y].right==1): _DrawDoor(x,y,2,1)
			if (self.proceduralData.data[x][y].up==1): _DrawDoor(x,y,1,0)
			if (self.proceduralData.data[x][y].down==1): _DrawDoor(x,y,1,2)
	
	pass

func _DrawCell(x:int,y:int):
	
	for rx in range(0,3):
		for ry in range(0,3):
			self.paint_rooms.lock()
			self.paint_rooms.set_pixel(x*3+rx,y*3+ry,Color.red)
			self.paint_rooms.unlock()
	self.paint_rooms.lock()
	self.paint_rooms.set_pixel(x*3+1,y*3+1,Color.black)
	self.paint_rooms.unlock()
	
func _DrawDoor(x:int,y:int,wx:int,wy:int):
	self.paint_rooms.lock()
	self.paint_rooms.set_pixel(x*3+wx,y*3+wy,Color.green)
	self.paint_rooms.unlock()