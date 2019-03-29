extends TextureRect


var proceduralData

func _ready():

	self.proceduralData = Utils.FindNode("Maze")

	if self.proceduralData==null: print("ERROR: missing ProcedralData class in scene")
	pass

func _process(delta):
	pass

func _draw():
	print("Preview")
	PreviewAsOverlay()


func PreviewAsOverlay():
	
#	#clear cells
#	for x in range(self.proceduralData.width*2):
#		for y in range(self.proceduralData.height*2):
#			var cx = x*2+1
#			var cy = y*2+1
#			draw_circle(Vector2(8+4*cx-8,8+4*cy),4.0,Color(0,0,0,1))
			
	# draw walls
#	for x in range(self.proceduralData.width):
#		for y in range(self.proceduralData.height):
#			self._DrawCell(x,y)
			var x = 0
			var y = 0
			self._DrawCell(x,y)
			if (self.proceduralData.data[x][y].left == 1): _DrawDoor(x-1,y)
			if (self.proceduralData.data[x][y].right == 1): _DrawDoor(x+1,y)
			if (self.proceduralData.data[x][y].up == 1): _DrawDoor(x,y-1)
			if (self.proceduralData.data[x][y].down == 1): _DrawDoor(x,y+1)

	
#	pass

func _DrawCell(x:int,y:int):
	var dot_size = 2
	var ox = 16+(dot_size*4)*x
	var oy = 16+(dot_size*4)*y
	for rx in range(x-1,x+2):
		for ry in range(y-1,y+2):
			draw_circle(Vector2(ox+(dot_size*2)*rx,oy+(dot_size*2)*ry),dot_size,Color(1,1,1,1))
	
	draw_circle(Vector2(ox+(dot_size*2)*x,oy+(dot_size*2)*y),dot_size,Color(0,0,0,1))
	
func _DrawDoor(x:int,y:int):
	var dot_size = 2
	var ox = 16+(dot_size*4)*x
	var oy = 16+(dot_size*4)*y
	draw_circle(Vector2(ox+(dot_size*2)*x,oy+(dot_size*2)*y),dot_size,Color(0,0,0,1))