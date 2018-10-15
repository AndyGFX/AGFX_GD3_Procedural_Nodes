extends "ProceduralData.gd"

export (int, 100) var cellSpawnChance = 50
export (int, 1,8) var birthLimit = 4
export (int, 1,8) var deathLimit = 4
export (int, 1,10) var repeatCount = 3

export var invert = false;

var sorroundCells = Array()


func _ready():

	self.sorroundCells.append(Vector2(-1,-1))
	self.sorroundCells.append(Vector2(-1,0))
	self.sorroundCells.append(Vector2(-1,1))

	self.sorroundCells.append(Vector2(0,-1))	
	self.sorroundCells.append(Vector2(0,1))

	self.sorroundCells.append(Vector2(1,-1))
	self.sorroundCells.append(Vector2(1,0))
	self.sorroundCells.append(Vector2(1,1))

	
	self.Create(0)
	self.Clean(0)
	self.Build()
	
	pass

func Build():
	self.done = false
	self.RandomFill(0,1,self.cellSpawnChance)
	self.GenerateMap()
	if self.invert: self.InvertMap()
	self.done = true
	
func GenerateMap():
	for i in range(self.repeatCount):
		self.data = self.SetMapCells(self.data)
		pass
	pass

func SetMapCells(oldMap):
	var newMap = []
	var neighb = 0

	for x in range(self.width):
		newMap.append([])
		for y in range(self.height):
			newMap[x].append(0)

	for x in range(self.width):		
		for y in range(self.height):
			neighb = 0
			for b in self.sorroundCells:				
				if (b.x == 0 and b.y == 0): 
					continue
				if (x + b.x >= 0 and x + b.x < self.width and y + b.y >= 0 and y + b.y < self.height):
					neighb += oldMap[x + b.x][ y + b.y]
				else:
					neighb+=1;

			if (oldMap[x][y]==1):
				if (neighb < self.deathLimit):
					newMap[x][y] = 0 
				else: 
					newMap[x][y] = 1
					
			if (oldMap[x][y]==0):
				if (neighb > self.birthLimit): 
					newMap[x][y] = 1 
				else: 
					newMap[x][y] = 0
	return newMap	

