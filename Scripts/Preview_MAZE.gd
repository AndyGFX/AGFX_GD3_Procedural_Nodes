extends Node2D


var proceduralData

var paint:Image

func _ready():

	self.proceduralData = ProceduralMaze.new();
	
	#if self.proceduralData==null: print("ERROR: missing ProcedralData class in scene")
	
	self.paint = Image.new()
	
	self.paint.create(self.proceduralData.width*4,self.proceduralData.height*4,false,Image.FORMAT_RGBA8)
	self.proceduralData.Build()
	
	Utils.SaveJSON("result.json",self.proceduralData.data)
	pass

func _draw():

	
	PreviewAsOverlay()
	
	
	var itex = ImageTexture.new()    
	#itex.set_storage(ImageTexture.STORAGE_RAW)
	itex.create_from_image(self.paint,0)
	$Preview.set_texture(itex)


func PreviewAsOverlay():
	
			
#	# draw walls
#	for x in range(0,self.proceduralData.width):
#		for y in range(0,self.proceduralData.height):
#			self._DrawCell(x,y)
			
	for x in range(0,self.proceduralData.width):
		for y in range(0,self.proceduralData.height):

			if (self.proceduralData.data[x][y].left): _DrawDoor(x-1,y)
			if (self.proceduralData.data[x][y].right): _DrawDoor(x+1,y)
			if (self.proceduralData.data[x][y].up): _DrawDoor(x,y-1)
			if (self.proceduralData.data[x][y].down): _DrawDoor(x,y+1)
	
#	pass

func _DrawCell(x:int,y:int):
	
	for rx in range(x-1,x+2):
		for ry in range(y-1,y+2):
			self.paint.lock()
			self.paint.set_pixel((x+1)*2+rx,(y+1)*2+ry,Color(1,1,1,1))
			self.paint.unlock()
			#draw_circle(Vector2(ox+(dot_size*2)*rx,oy+(dot_size*2)*ry),dot_size,Color(1,1,1,1))
	self.paint.lock()
	self.paint.set_pixel((x+1)*2+x,(y+1)*2+y,Color(0,0,0,1))
	self.paint.unlock()
	
func _DrawDoor(x:int,y:int):
	self.paint.lock()
	self.paint.set_pixel(x+((x+1)*2),y+((y+1)*2),Color(0,0,0,1))
	self.paint.unlock()