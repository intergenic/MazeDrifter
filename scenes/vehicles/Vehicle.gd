extends KinematicBody2D

export var wheel_base = 70  # Distance from front to rear wheel
export var steering_angle = 15  # Amount that front wheel turns, in degrees
export var drift_steering_angle = 25
export var engine_power = 800  # Forward acceleration force.
export var braking = -450
export var max_speed_reverse = 250
export var acceleration = Vector2.ZERO


var traction_fast = 0.00001  # High-speed traction
var traction_slow = 0.2  # Low-speed traction
var friction = -0.9
var drag = -0.0015
var velocity = Vector2.ZERO
var steer_angle
var is_handbraking = false
var start_location
var start_rotation
var collided = false
onready var _animated_sprite = $AnimatedSprite
onready var _sprite = $Sprite
onready var _fl_trail = $TrailPositionFrontLeft/TrailLine
onready var _rl_trail = $TrailPositionRearLeft/TrailLine
onready var _fr_trail = $TrailPositionFrontRight/TrailLine
onready var _rr_trail = $TrailPositionRearRight/TrailLine


func _ready():
	start_location = self.position
	start_rotation = self.rotation
	_sprite.visible = true
	_animated_sprite.visible = false

func _physics_process(delta):
	if !collided:
		get_input()
		apply_friction()
		calculate_steering(delta)
		velocity += acceleration * delta
		#var collision = move_and_collide(velocity)
		#if collision:
		#	print("Collision detected")
		velocity = move_and_slide(velocity)
		check_collisions()
	
func check_collisions():
	for i in get_slide_count():
		#var collision = get_slide_collision(i)
		player_death()

func player_death():
	collided = true #Stop movement
	_sprite.visible = false
	_animated_sprite.visible = true
	_animated_sprite.play("explosion")
	yield(_animated_sprite,"animation_finished")
	#After explosion animation, reset and remove skid marks
	velocity = Vector2.ZERO
	#is_handbraking = false
	reset_skidmarks(_fl_trail)
	reset_skidmarks(_rl_trail)
	reset_skidmarks(_fr_trail)
	reset_skidmarks(_rr_trail)
	self.position = start_location
	self.rotation = start_rotation
	_sprite.visible = true
	_animated_sprite.play("idle")
	_animated_sprite.visible = false
	collided = false

func reset_skidmarks(trail):
	trail.clear_points()
	trail.timer = 0


func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	is_handbraking = Input.is_action_pressed("handbrake")
	if is_handbraking:
		steer_angle = turn * deg2rad(drift_steering_angle)
	else:
		steer_angle = turn * deg2rad(steering_angle)
	acceleration = Vector2.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * braking
	

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func calculate_steering(delta):
	
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if is_handbraking:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func body_entered():
	print("Body entered")
