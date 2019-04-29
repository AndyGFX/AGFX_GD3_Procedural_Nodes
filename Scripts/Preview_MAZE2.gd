extends Node2D


export var userSeed:int = 2019
export var randomSeed:bool = false
export var mazeWidth:int = 57
export var mazeHeight:int = 57
var proceduralData

var paint:Image

func _ready():

	self.proceduralData = ProceduralMaze.new(self.mazeWidth,self.mazeHeight,self.randomSeed,userSeed);
	
	self.paint = Image.new()	
	self.paint.create(self.proceduralData.width*2+1,self.proceduralData.height*2+1,false,Image.FORMAT_RGBA8)
	
	
	self.proceduralData.invert = true	
	self.proceduralData.Build()
	
	pass

func _draw():

	
	PreviewAsOverlay()
	
	
	var itex = ImageTexture.new()    	
	itex.create_from_image(self.paint,0)
	$Preview.set_texture(itex)


func PreviewAsOverlay():

	for x in range(0,self.proceduralData.width):
		for y in range(0,self.proceduralData.height):
			self.paint.lock()
			if (self.proceduralData.data[x][y].value==1):
				self.paint.set_pixel(x,y,Color(1,1,1,1))
			else:
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			self.paint.unlock()
	
	pass
