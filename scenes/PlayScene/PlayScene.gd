extends Node2D




var initialized_map = false
onready var _maze = $Maze
onready var _vehicle = $Vehicle

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Playing play scene")

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !_maze.is_initialized:
		update_map()

	

func update_map():
	_maze.initialize_values()
	_maze.set_camera()
	_maze.make_maze()
	_maze.erase_walls()
	_maze.place_finish_line()
	_maze.is_initialized = true
