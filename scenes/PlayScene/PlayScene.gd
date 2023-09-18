extends Node2D


var maze
var player_vehicle

var initialized_map = false


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Playing play scene")
	maze = get_node("Maze")
	player_vehicle = get_node("Vehicle")

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !initialized_map:
		update_map()

func update_map():
	maze.initialize_values()
	maze.set_camera()
	maze.make_maze()
	maze.erase_walls()
	initialized_map = true
