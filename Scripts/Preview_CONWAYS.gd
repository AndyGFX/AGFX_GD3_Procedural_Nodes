extends Node2D

var procedural
var paint:Image

func _ready():

	self.procedural = ProceduralConways.new(128,128)
	
	
	self.procedural.birthLimit = 4
	self.procedural.cellSpawnChance = 50
	self.procedural.birthLimit = 4
	self.procedural.deathLimit = 4
	self.procedural.repeatCount = 4	
	
	self.paint = Image.new()	
	self.paint.create(self.procedural.width,self.procedural.height,false,Image.FORMAT_RGBA8)
	
	
	self.procedural.Build()
	self.procedural.InvertMap()
	
	pass

func _process(delta):
	pass

func _draw():
	PreviewAsOverlay()
	var itex = ImageTexture.new()    
	#itex.set_storage(ImageTexture.STORAGE_RAW)
	itex.create_from_image(self.paint,0)
	$Preview.set_texture(itex)
	

func PreviewAsOverlay():
	print("Redraw")
	for x in range(self.procedural.width):
		for y in range(self.procedural.height):
			self.paint.lock()
			if (self.procedural.data[x][y]==0):
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			if (self.procedural.data[x][y]==1):
				self.paint.set_pixel(x,y,Color(1,1,1,1))
				self.paint.unlock()

	pass
