extends TextureRect


export (String,"Conways","Maze" ) var nodeName = "undefined"

var proceduralData

func _ready():
	
	self.proceduralData = Utils.FindNode(self.nodeName)
	
	if self.proceduralData==null: print("ERROR: missing ProcedralData class in scene")
	pass

func _process(delta):
	pass

func _draw():
	PreviewAsOverlay()
	
	
func PreviewAsOverlay():
	print("Redraw")
	for x in range(self.proceduralData.width):
		for y in range(self.proceduralData.height):
			if (self.proceduralData.data[x][y].down==0):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y].down==1):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(1,1,1,1))
			if (self.proceduralData.data[x][y].right==0):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y].right==1):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(1,1,1,1))
	pass
	
	
#
#func PreviewAsTexture():
#	var imageTexture = ImageTexture.new()
#	var img = Image.new()    
#	img.create(self.conways.width,self.conways.height,false,Image.FORMAT_RGB8)
#	img.fill(Color(1,1,1,1))
#	img.lock()
#
#	for x in range(self.conways.width):
#		for y in range(self.conways.height):
#			if (self.conways.data[x][y]==1): img.set_pixel(x,y,Color(0,0,0,1))
#	img.unlock()
#	imageTexture.create_from_image(img)
#	self.texture = imageTexture
#	imageTexture.resource_name = "The created texture!"
