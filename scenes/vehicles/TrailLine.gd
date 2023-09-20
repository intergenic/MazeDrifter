extends Line2D

export var length = 50
export var fadeTime = 1
var point
var timer = 0

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	point = get_parent().global_position
	if Input.is_action_just_pressed("handbrake"):
		clear_points()
		timer = 0
	if Input.is_action_pressed("handbrake"):
		timer += delta
		add_point(point)
		if points.size() > length || timer > fadeTime:
			remove_point(0)
	else:
		if points.size() >= 1:
			remove_point(0)
