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
	pass