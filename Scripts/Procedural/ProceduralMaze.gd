extends "ProceduralData.gd"

export var invert = false;
export var removeWalls = false;

export var start = Vector2(1,1)

var cell = { "left": 0,"right": 0,"up": 0,"down": 0,"visited": 0,}

func _ready():
	self.Create(cell)
	self.Clean(cell)
	self.Build()
	pass

func Build():
	self.done = false
	self.GenerateMap()
	if self.invert: self.InvertMap()
	self.done = true
	
func GenerateMap():
	var i = 0
	var j = 0
	for y in range(self.height-1):
		for x in range(self.width-1):
			i = y 
			j = x 
			print(i,",",j)
			if ((i==self.height) and (i==self.width)):
				pass
			else:
				if i==self.height:
					self.data[i][j].right = 1
					self.data[i][j+1].left = 1
					pass
				else:
					if j==self.width:
						self.data[i][j].down = 1
						self.data[i+1][j].up = 1
					else:
						if floor(randi()%2)==0:
							
							self.data[i][j].right = 1
							self.data[i][j+1].left = 1
							pass
						else:
							self.data[i][j].down = 1
							self.data[i+1][j].up = 1
	pass