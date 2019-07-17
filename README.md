# Godot 3.1 Procedural Nodes

- ## CONWAYS
    - class: `ProceduralConways`
        - properties:
            - cellSpawnChance
            - birthLimit
            - deathLimit
            - repeatCount
            - invert
        - method:
            - xyz.new(width,height)
            - xyz.Build()
        - result:
            - is stored in 2D array [0 - empty, 1 - filled]

- ## MAZE
    - class: `ProceduralMaze`
        - properties:
            - userSeed: user defined seed for build maze
            - randomSeed: generate random seed (if true -> userSeed is ignored)
            - invert: invert generated data
            - mazeWidth
            - mazeHeight
        - methods:
            - xyz.new(width,height,randomSeed,userSeed)
            - xyz.Build()
        - result:
            - is stored in 2D array [0 - empty, 1 - filled]

- ## ROOM
    - class: `ProcedureRoom`
        - properties:
            - userSeed: user defined seed for build rooms
            - randomSeed: generate random seed (if true -> userSeed is ignored)
            - invert: invert generated data
            - room_count: Vector2(rooms count in X, rooms count in Y)
        - method:
            - xyz.new(room count x,room count y,randomSeed,userSeed)
            - xyz.Build()
        - result:
            - stored in 2D array with structure

```
                    class empty_room:
                    
                        var up:int
                        var right:int
                        var down:int
                        var left:int
                        var visited:int
```
# Examples
    - TEST_Maze.tscn

![Alt text](Screenshots/Maze.png?raw=true "PREVIEW")

    - Test_ROOMS.tscn
![Alt text](Screenshots/Rooms.png?raw=true "PREVIEW")

    - Test_CONWAYS.tscn
    
![Alt text](Screenshots/Conways.png?raw=true "PREVIEW")

# Screenshots

                    
