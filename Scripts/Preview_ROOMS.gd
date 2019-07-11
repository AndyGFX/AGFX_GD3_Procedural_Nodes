extends Node2D


export var room_count:Vector2 = Vector2(5,5)
export var userSeed:int = 2019
export var RandomSeed:bool = false
var proceduralData
var paint_maze:Image
var paint_rooms:Image
var rscale:int = 5


func _ready():
	
	# build rooms
	self.proceduralData = ProceduralRooms.new(self.room_count.x,self.room_count.y,self.RandomSeed,self.userSeed)	
	self.proceduralData.Build()
	
	# preview rooms as texture
	self.paint_maze = Image.new()	
	self.paint_maze.create(self.proceduralData.width*2+1,self.proceduralData.height*2+1,false,Image.FORMAT_RGBA8)	
	
	self.paint_rooms = Image.new()	
	self.paint_rooms.create(self.proceduralData.width*self.rscale,self.proceduralData.height*self.rscale,false,Image.FORMAT_RGBA8)	

	

func _draw():

	
	PreviewMaze()
	$Preview_MAZE.set_texture(Utils.CreateTextureFromImage(self.paint_maze))
	
	PreviewRooms()
	$Preview_ROOMS.set_texture(Utils.CreateTextureFromImage(self.paint_rooms))
	
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
		
			if (self.proceduralData.data[x][y].left==1): _DrawDoor(x,y,0,2)
			if (self.proceduralData.data[x][y].right==1): _DrawDoor(x,y,4,2)
			if (self.proceduralData.data[x][y].up==1): _DrawDoor(x,y,2,0)
			if (self.proceduralData.data[x][y].down==1): _DrawDoor(x,y,2,4)
	
	pass


func _DrawCell(x:int,y:int):
	
	for rx in range(0,self.rscale):
		for ry in range(0,self.rscale):
			self.paint_rooms.lock()
			self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.white)
			if rx==0: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if rx==self.rscale-1: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==0: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==self.rscale-1: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			self.paint_rooms.unlock()
#	self.paint_rooms.lock()
#	self.paint_rooms.set_pixel(x*self.rscale+2,y*self.rscale+2,Color.black)
#	self.paint_rooms.unlock()
	
func _DrawDoor(x:int,y:int,wx:int,wy:int):
	self.paint_rooms.lock()
	self.paint_rooms.set_pixel(x*self.rscale+wx,y*self.rscale+wy,Color.white)
	self.paint_rooms.unlock()