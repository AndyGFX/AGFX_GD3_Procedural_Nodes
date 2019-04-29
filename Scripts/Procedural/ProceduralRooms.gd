extends "ProceduralData.gd"

class_name ProceduralRooms

var invert = false;
var room_count = Vector2(5,5)
var maze
var user_seed = 0

class empty_room:
	var up:int = 1
	var right:int = 1
	var down:int = 1
	var visited:int = 0

func _init(x:int,y:int,rnd:bool,useed:int):
	self.room_count = Vector2(x,y)
	self.maze = ProceduralMaze.new(self.room_count.x * 3,self.room_count.y * 3,rnd,useed)	
	pass
	
func _ready():
	self.Create(empty_room)
	self.Clean(empty_room)
	pass

func Random(mode):
	self.maze.randomSeed = mode

func Build():
	self.done = false
	self.GenerateMap()
	if self.invert: self.InvertMap()
	self.done = true

func InvertMap():
	pass

func GenerateMap():
	
	# generate maze
	self.maze.invert = true
	self.maze.Build()
	
	# create rooms from maze
	
	
	
	pass