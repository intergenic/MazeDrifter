extends Node2D


export var camera_transition_delay = 0.1

var initialized_map = false
var transitioned_camera = false
var is_resetting = false

onready var _maze = $Maze
onready var _vehicle = $Vehicle
onready var _shadow_sprite = $ShadowSprite
onready var _timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Playing play scene")
	_vehicle.camera.current = true

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _vehicle.is_active:
		update_score_timer(delta)
	if !_maze.is_initialized:
		print("Creating map")
		update_map() 
		_shadow_sprite.visible = false
	if _maze.is_initialized && !transitioned_camera:
		print("Transitioning camera")
		update_camera()
	if !_vehicle.is_alive && !is_resetting:
		is_resetting = true
		place_shadow()
		update_camera()

func update_score_timer(delta):
	GameManager.increment_score_timer(delta)
	Gui._timer_label.text = Utilites.seconds2mmss(GameManager.score_timer)

func place_shadow():
	_shadow_sprite.visible = true
	_shadow_sprite.position = _vehicle.death_location
	_shadow_sprite.rotation = _vehicle.death_rotation

func update_camera():
	_vehicle.is_active = false
	transitioned_camera = true
	CameraTransition.transition_camera2D(_maze.camera, _vehicle.camera, camera_transition_delay)
	#yield(get_tree().create_timer(camera_transition_delay), "timeout")
	_timer.set_wait_time(camera_transition_delay)
	_timer.start()

func enable_vehicle():
	_vehicle.is_active = true
	_vehicle.is_alive = true

func update_map():
	_maze.initialize_values()
	_maze.set_camera()
	_maze.make_maze()
	_maze.erase_walls()
	_maze.place_finish_line()
	_maze.is_initialized = true
	


func _on_Timer_timeout():
	enable_vehicle()
	is_resetting = false
