extends Node2D


export var camera_transition_delay = 0.1

var initialized_map = false
var transitioned_camera = false
onready var _maze = $Maze
onready var _vehicle = $Vehicle

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Playing play scene")
	_vehicle.camera.current = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !_maze.is_initialized:
		print("Creating map")
		update_map() 
	if _maze.is_initialized && !transitioned_camera:
		print("Transitioning camera")
		update_camera()
	if !_vehicle.is_alive:
		update_camera()
		

func update_camera():
	_vehicle.is_active = false
	transitioned_camera = true
	CameraTransition.transition_camera2D(_maze.camera, _vehicle.camera, camera_transition_delay)
	yield(get_tree().create_timer(camera_transition_delay), "timeout")
	_vehicle.is_active = true
	_vehicle.is_alive = true

func update_map():
	_maze.initialize_values()
	_maze.set_camera()
	_maze.make_maze()
	_maze.erase_walls()
	_maze.place_finish_line()
	_maze.is_initialized = true
	
