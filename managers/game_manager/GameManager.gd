extends Node



var maze_size = 3
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func increment_maze_size(n):
	maze_size += n
