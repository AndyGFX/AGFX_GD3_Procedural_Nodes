extends Node2D


var proceduralData

var paint:Image

func _ready():

	self.proceduralData = ProceduralMaze.new(56,56);
	
	
	self.paint = Image.new()	
	self.paint.create(self.proceduralData.width*2+1,self.proceduralData.height*2+1,false,Image.FORMAT_RGBA8)
	
	self.proceduralData.invert = false	
	self.proceduralData.Build()
	
	pass

func _draw():

	
	PreviewAsOverlay()
	
	
	var itex = ImageTexture.new()    
	#itex.set_storage(ImageTexture.STORAGE_RAW)
	itex.create_from_image(self.paint,0)
	$Preview.set_texture(itex)


func PreviewAsOverlay():
	
			
	# draw walls
	for x in range(0,self.proceduralData.width):
		for y in range(0,self.proceduralData.height):
			self._DrawCell(x,y)

	for x in range(0,self.proceduralData.width):
		for y in range(0,self.proceduralData.height):
			#if (self.proceduralData.data[x][y].left): _DrawDoor(x,y,0,1)
			if (!self.proceduralData.data[x][y].right): _DrawDoor(x,y,2,1)
			#if (self.proceduralData.data[x][y].up): _DrawDoor(x,y,1,0)
			if (!self.proceduralData.data[x][y].down): _DrawDoor(x,y,1,2)
	
	pass

func _DrawCell(x:int,y:int):
	
	for rx in range(0,3):
		for ry in range(0,3):
			self.paint.lock()
			self.paint.set_pixel(x*2+rx,y*2+ry,Color(1,1,1,1))
			self.paint.unlock()
	self.paint.lock()
	self.paint.set_pixel(x*2+1,y*2+1,Color(0,0,0,1))
	self.paint.unlock()
	
func _DrawDoor(x:int,y:int,wx:int,wy:int):
	self.paint.lock()
	self.paint.set_pixel(x*2+wx,y*2+wy,Color(0,0,0,1))
	self.paint.unlock()