extends Node2D


export (int, 100) var cellSpawnChance = 50
export (int, 1,8) var birthLimit = 4
export (int, 1,8) var deathLimit = 4
export (int, 1,10) var repeatCount = 4

export var invert = false;

var procedural
var paint:Image

func _ready():

	self.procedural = ProceduralConways.new(24,24)
	
	
	
	self.procedural.cellSpawnChance = self.cellSpawnChance
	self.procedural.birthLimit = self.birthLimit
	self.procedural.deathLimit = self.deathLimit
	self.procedural.repeatCount = self.repeatCount
	
	self.paint = Image.new()	
	self.paint.create(self.procedural.width,self.procedural.height,false,Image.FORMAT_RGBA8)
	
	
	self.procedural.Build()
	if self.invert: self.procedural.InvertMap()
	
	pass

func _process(delta):
	pass

func _draw():
	PreviewAsOverlay()
	var itex = ImageTexture.new()    
	itex.create_from_image(self.paint,0)
	$Preview.set_texture(itex)
	

func PreviewAsOverlay():
	
	for x in range(self.procedural.width):
		for y in range(self.procedural.height):
			self.paint.lock()
			if (self.procedural.data[x][y].value==0):
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			if (self.procedural.data[x][y].value==1):
				self.paint.set_pixel(x,y,Color(1,1,1,1))
				self.paint.unlock()

	pass


func _on_Button_pressed():
	self.procedural.Build()
	if self.invert: self.procedural.InvertMap()
	update()
	pass # Replace with function body.
