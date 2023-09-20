extends Node



var maze_size = 4
var score_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func increment_maze_size(n):
	maze_size += n


func increment_score_timer(delta):
	score_timer += delta



