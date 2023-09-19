extends Node2D


const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1,0): E, Vector2(-1,0): W,
	Vector2(0,1): S, Vector2(0,-1): N}

export var tile_size = 512 # tile size in pixels
export var map_size = 5 # Size in tiles. Square mazes only
var width = 1 # maze width in tiles
var height = 1 # maze height in tiles
export var erase_fraction = 0.2
var is_initialized = false


onready var Map = $TileMap
onready var finish_line = $FinishLine
onready var camera = $Camera2D

func _ready():
	#randomize()
	#width = map_size
	#height = map_size
	#set_camera() #called externally
	#tile_size = Map.cell_size
	#make_maze() #called externally
	pass

func initialize_values():
	randomize()
	width = GameManager.maze_size
	height = GameManager.maze_size
	print("Width: " + str(width) + " Height: " + str(height))
	#tile_size = Map.cell_size

func set_camera():
	camera.translate(Vector2((tile_size * 0.5 * width), (tile_size * 0.5 * height)))
	camera.zoom = Vector2(width,height)

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = []
	var stack = []
	Map.clear()
	# Fill map with solid tiles
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x,y))
			Map.set_cellv(Vector2(x,y), N|E|S|W)
	var current = Vector2(0,0)
	unvisited.erase(current)
	var is_first = true
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			# Ensure that the first tile (0,0) always opens to the right,
			# so that the player vehicle is always facing an opening on start
			if is_first:
				next = current + Vector2(1,0)
				is_first = false
			stack.append(current)
			# remove walls from both cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#yield(get_tree(), 'idle_frame')

func erase_walls():
# warning-ignore:unused_variable
	for i in range(int(width * height * erase_fraction)):
		var x = int(rand_range(1, width - 1))
		var y = int(rand_range(1, height - 1))
		var cell = Vector2(x, y)
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		if Map.get_cellv(cell) & cell_walls[neighbor]:
			var walls = Map.get_cellv(cell) - cell_walls[neighbor]
			var n_walls = Map.get_cellv(cell + neighbor) - cell_walls[-neighbor]
			Map.set_cellv(cell, walls)
			Map.set_cellv(cell + neighbor, n_walls)

func place_finish_line():
	#x/y coordinates in tilemap
	#Ensure that it is in bottom right quadrant
	var x = (width / 2) + randi() % (width - 2)
	var y = (height / 2) + randi() % (height - 2)
	if x >= width:
		x -= 1
	if y >= height:
		y -= 1
	print("X:" + str(x) + " Y:" + str(y))
	#Convert to pixel coordinates
	var x_offset = (x * tile_size) - (0.5 * tile_size)
	var y_offset = (y * tile_size) - (0.5 * tile_size)
	print("X_off:" + str(x_offset) + " Y_off:" + str(y_offset))
	finish_line.position = Vector2(x_offset, y_offset)
	


# warning-ignore:unused_argument
func _on_FinishLine_area_entered(area):
	print("Finish reached (maze node)")
	GameManager.increment_maze_size(1)
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
