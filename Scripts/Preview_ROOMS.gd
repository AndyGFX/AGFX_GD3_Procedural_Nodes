extends Node2D


export var room_count:Vector2 = Vector2(5,5)
export var userSeed:int = 2019
export var RandomSeed:bool = false
var proceduralRoomData = null
var paint_maze:Image = null
var paint_rooms:Image = null
var rscale:int = 5


func _ready():
	
	# build rooms
	self.proceduralRoomData = ProceduralRooms.new(self.room_count.x,self.room_count.y,self.RandomSeed,self.userSeed)	
	self.proceduralRoomData.Build()
	
	# preview rooms as texture
	self.paint_maze = Image.new()	
	self.paint_maze.create(self.proceduralRoomData.width*2+1,self.proceduralRoomData.height*2+1,false,Image.FORMAT_RGBA8)	
	
	self.paint_rooms = Image.new()	
	self.paint_rooms.create(self.proceduralRoomData.width*self.rscale,self.proceduralRoomData.height*self.rscale,false,Image.FORMAT_RGBA8)	

	print(self.proceduralRoomData.ToString(0,0))

func _draw():

	
	PreviewMaze()
	$Preview_MAZE.set_texture(Utils.CreateTextureFromImage(self.paint_maze))
	
	PreviewRooms()
	$Preview_ROOMS.set_texture(Utils.CreateTextureFromImage(self.paint_rooms))
	
func PreviewMaze()->void:

	for x in range(0,self.proceduralRoomData.maze.width):
		for y in range(0,self.proceduralRoomData.maze.height):
			self.paint_maze.lock()
			if (self.proceduralRoomData.maze.data[x][y].value==0):
				self.paint_maze.set_pixel(x,y,Color(0,0,0,1))
			else:
				self.paint_maze.set_pixel(x,y,Color(1,1,1,1))
			self.paint_maze.unlock()
	
	pass


func PreviewRooms()->void:
			
	# draw walls
	for x in range(0,self.proceduralRoomData.width):
		for y in range(0,self.proceduralRoomData.height):
			self._DrawCell(x,y)

	# draw doors
	for y in range(0,self.proceduralRoomData.height):
		for x in range(0,self.proceduralRoomData.width):
		
			if (self.proceduralRoomData.data[x][y].left==1): _DrawDoor(x,y,0,2)
			if (self.proceduralRoomData.data[x][y].right==1): _DrawDoor(x,y,4,2)
			if (self.proceduralRoomData.data[x][y].up==1): _DrawDoor(x,y,2,0)
			if (self.proceduralRoomData.data[x][y].down==1): _DrawDoor(x,y,2,4)
	
	pass


func _DrawCell(x:int,y:int)->void:
	
	for rx in range(0,self.rscale):
		for ry in range(0,self.rscale):
			self.paint_rooms.lock()
			self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.white)
			if rx==0: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if rx==self.rscale-1: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==0: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==self.rscale-1: self.paint_rooms.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			self.paint_rooms.unlock()

	
func _DrawDoor(x:int,y:int,wx:int,wy:int)->void:
	self.paint_rooms.lock()
	self.paint_rooms.set_pixel(x*self.rscale+wx,y*self.rscale+wy,Color.white)
	self.paint_rooms.unlock()