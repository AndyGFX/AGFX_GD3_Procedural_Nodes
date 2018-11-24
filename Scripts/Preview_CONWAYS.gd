extends TextureRect

var proceduralData

func _ready():

	self.proceduralData = Utils.FindNode("Conways")

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
			if (self.proceduralData.data[x][y]==0):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(0,0,0,1))
			if (self.proceduralData.data[x][y]==1):
				draw_circle(Vector2(8+x*2,8+y*2),1.0,Color(1,1,1,1))

	pass
