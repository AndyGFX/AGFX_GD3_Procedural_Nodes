extends Node2D

export var width = 64
export var height = 64
export var randomSeed = true
export var _seed_ = 123456
var data = []



func Create():
	for x in range(self.width):
		self.data.append([])
		for y in range(self.height):
			self.data[x].append(0)

func Clean():
	for x in range(self.width):		
		for y in range(self.height):
			self.data[x][y] = 0

func RandomFill(empty,fill,chance):
	if (self.randomSeed):
		randomize()
		self._seed_ = randi()
	
	seed(self._seed_)	

	for x in range(self.width):		
		for y in range(self.height):						
			if (randi()%100)<chance:
				self.data[x][y] = empty
			else:
				self.data[x][y] = fill
	pass