extends "ProceduralData.gd"

export (int, 100) var cellSpawnChance = 50
export (int, 1,8) var birthLimit = 4
export (int, 1,8) var deathLimit = 4
export (int, 1,10) var repeatCount = 3
export var realTime = false
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

	self.Create()
	self.Clean()
	self.Build()
	
	pass

func Build():
	self.RandomFill(0,1,self.cellSpawnChance)
	self.GenerateMap()
	self.PreviewAsTexture()	

func _process(delta):
	if realTime:
		Build()

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

func PreviewAsTexture():
	var imageTexture = ImageTexture.new()
	var img = Image.new()    
	img.create(self.width,self.height,false,Image.FORMAT_RGB8)
	img.fill(Color(1,1,1,1))
	img.lock()
	
	for x in range(self.width):
		for y in range(self.height):
			if (self.data[x][y]==1): img.set_pixel(x,y,Color(0,0,0,1))
	img.unlock()
	imageTexture.create_from_image(img)
	$Preview.texture = imageTexture
	imageTexture.resource_name = "The created texture!"	
	

