extends Node2D


export var room_count:Vector2 = Vector2(5,5)
export var userSeed:int = 2019
export var RandomSeed:bool = false
var proceduralDungeonData = null
var paint_cells:Image = null
var paint_dungeons:Image = null
var rscale:int = 7


func _ready():
	
	# build rooms
	self.proceduralDungeonData = ProceduralDungeon.new(self.room_count.x,self.room_count.y,self.RandomSeed,self.userSeed)	
	self.proceduralDungeonData.Build()
	
	# preview rooms as texture
	self.paint_cells = Image.new()	
	self.paint_cells.create(self.proceduralDungeonData.width*2+1,self.proceduralDungeonData.height*2+1,false,Image.FORMAT_RGBA8)	
	
	self.paint_dungeons = Image.new()	
	self.paint_dungeons.create(self.proceduralDungeonData.width*self.rscale,self.proceduralDungeonData.height*self.rscale,false,Image.FORMAT_RGBA8)	


func _draw():

	
	PreviewMaze()
	$Preview_CELLS.set_texture(Utils.CreateTextureFromImage(self.paint_cells))
	
	PreviewRooms()
	$Preview_DUNGEON.set_texture(Utils.CreateTextureFromImage(self.paint_dungeons))
	
func PreviewMaze()->void:

	for x in range(0,self.proceduralDungeonData.cells.width):
		for y in range(0,self.proceduralDungeonData.cells.height):
			self.paint_cells.lock()
			if (self.proceduralDungeonData.cells.data[x][y].value==0):
				self.paint_cells.set_pixel(x,y,Color(0,0,0,1))
			else:
				self.paint_cells.set_pixel(x,y,Color(1,1,1,1))
			self.paint_cells.unlock()
	
	pass


func PreviewRooms()->void:
			
	# draw walls
	for x in range(0,self.proceduralDungeonData.width):
		for y in range(0,self.proceduralDungeonData.height):
			self._DrawCell(x,y)
			#print("["+String(x)+","+String(y)+"]="+self.proceduralDungeonData.ToString(x,y)) 

	# draw doors
	for y in range(0,self.proceduralDungeonData.height):
		for x in range(0,self.proceduralDungeonData.width):
		
			if (self.proceduralDungeonData.data[x][y].left==1): _DrawDoor(x,y,0,floor(rscale/2.0))
			if (self.proceduralDungeonData.data[x][y].right==1): _DrawDoor(x,y,2*floor(rscale/2.0),floor(rscale/2.0))
			if (self.proceduralDungeonData.data[x][y].up==1): _DrawDoor(x,y,floor(rscale/2.0),0)
			if (self.proceduralDungeonData.data[x][y].down==1): _DrawDoor(x,y,floor(rscale/2.0),2*floor(rscale/2.0))
	
	pass


func _DrawCell(x:int,y:int)->void:
	
	for rx in range(0,self.rscale):
		for ry in range(0,self.rscale):
			self.paint_dungeons.lock()
			self.paint_dungeons.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.white)
			if rx==0: self.paint_dungeons.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if rx==self.rscale-1: self.paint_dungeons.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==0: self.paint_dungeons.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			if ry==self.rscale-1: self.paint_dungeons.set_pixel(x*self.rscale+rx,y*self.rscale+ry,Color.red)
			self.paint_dungeons.unlock()

	
func _DrawDoor(x:int,y:int,wx:int,wy:int)->void:
	self.paint_dungeons.lock()
	self.paint_dungeons.set_pixel(x*self.rscale+wx,y*self.rscale+wy,Color.white)
	self.paint_dungeons.unlock()
	
