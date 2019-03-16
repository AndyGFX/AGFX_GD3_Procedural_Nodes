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
			var x = 0
			var y = 0
			var cx = x*3+1
			var cy = y*3+1
			if (self.proceduralData.data[x][y].left == 1): draw_circle(Vector2(8+4*cx-8,8+4*cy),4.0,Color(1,1,1,1))
			if (self.proceduralData.data[x][y].left == 0): draw_circle(Vector2(8+4*cx-8,8+4*cy),4.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y].right == 1): draw_circle(Vector2(8+4*cx+8,8+4*cy),4.0,Color(1,1,1,1))
			if (self.proceduralData.data[x][y].right == 0): draw_circle(Vector2(8+4*cx+8,8+4*cy),4.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y].up == 1): draw_circle(Vector2(8+4*cx,8+4*cy-8),4.0,Color(1,1,1,1))
			if (self.proceduralData.data[x][y].up == 0): draw_circle(Vector2(8+4*cx,8+4*cy-8),4.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y].down == 1): draw_circle(Vector2(8+4*cx,8+4*cy+8),4.0,Color(1,1,1,1))
			if (self.proceduralData.data[x][y].down == 0): draw_circle(Vector2(8+4*cx,8+4*cy+8),4.0,Color(0,0,0,1))

#	pass
