extends Node2D


export var room_count:Vector2 = Vector2(5,5)
export var userSeed:int = 2019
export var RandomSeed:bool = false
var proceduralData
var paint:Image


func _ready():
	
	
	self.proceduralData = ProceduralRooms.new(self.room_count.x,self.room_count.y,self.RandomSeed,self.userSeed)
	
	self.paint = Image.new()	
	self.paint.create(self.proceduralData.room_count.x*3,self.proceduralData.room_count.y*3,false,Image.FORMAT_RGBA8)	
	
	pass # Replace with function body.
	self.proceduralData.Build()
	

func _draw():

	
	PreviewAsOverlay()
	
	
	var itex = ImageTexture.new()    	
	itex.create_from_image(self.paint,0)
	$Preview_MAZE.set_texture(itex)
	
func PreviewAsOverlay():

	for x in range(0,self.proceduralData.maze.width):
		for y in range(0,self.proceduralData.maze.height):
			self.paint.lock()
			if (self.proceduralData.maze.data[x][y].value==1):
				self.paint.set_pixel(x,y,Color(1,1,1,1))
			else:
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			self.paint.unlock()
	
	pass
