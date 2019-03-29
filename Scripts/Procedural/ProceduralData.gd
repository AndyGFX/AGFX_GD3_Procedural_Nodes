extends Node2D


export var width = 32
export var height = 32
export var randomSeed = true
export var _seed_ = 123456
var data = []
var done = false;


func Create(type_of):
	for x in range(self.width):
		self.data.append([])
		for y in range(self.height):
			self.data[x].append(type_of.new())

func Clean(type_of):
	for x in range(self.width):		
		for y in range(self.height):
			self.data[x][y] = type_of.new()

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

func InvertMap():
	for x in range(self.width):		
		for y in range(self.height):
			if self.data[x][y] == 0:
				self.data[x][y] = 1
			elif self.data[x][y] == 1:
				self.data[x][y] = 0