extends  Node2D

# room's parameters
const TILE_SOURCE_ID := 0
const TILE_ATLAS_FLOOR := Vector2i(2, 0)
const TILE_ATLAS_WALL := Vector2i(1, 0)
const TILE_ATLAS_VOID := Vector2i(0, 0)
@export var room_height: int = 40
@export var room_width: int = 72
var room: Array = []
var room_center: Vector2 = Vector2(floori((room_width - 1) / 2.0), floori((room_height - 1) / 2.0))
@onready var tilemap = get_node("TileMapLayer")

# Walkers' parameters
@export var chance_walker_change_dir: float = 0.5
@export var chance_walker_spawn: float = 0.05
@export var chance_walker_destoy: float = 0.05
@export var max_walkers: int = 20
@export var percent_to_fill: float = 0.1
var iteration: int = 0
var amount_of_iterations: int = 1000
var walkers: Array = []

# the Walker class represents a single “walker” that builds floors:
class Walker:
	var pos := Vector2()
	var dir := Vector2()

	func _init(pos_par: Vector2, dir_par: Vector2) -> void:
		pos = pos_par
		dir = dir_par

func _ready() -> void:
	init_room()
	#seed(1)
	#print_room()
	walkers.append(Walker.new(room_center, rand_dir()))
	#print_walker(0)
	create_floors()
	#print_room()
	create_walls()
	remove_single_walls()
	#print_room()
	fill_tilemap_from_room()

# debug prints
func print_room() -> void:
	print("Current room state:")
	for row in range(room_height):
		print(room[row])
func print_walker(index: int) -> void:
	print("Walker's ", index, " info:")
	print("position = ", walkers[index].pos)
	print("direction = ", walkers[index].dir)

func init_room() -> void:
	room.resize(room_height)
	for row in range(room_height):
		room[row] = []
		for cell in range(room_width):
			room[row].append(0)

# choosing random direction for walker to go
func rand_dir() -> Vector2:
	match randi_range(0, 4):
		0:
			return Vector2.UP
		1:
			return Vector2.LEFT
		2:
			return Vector2.DOWN
		_:
			return Vector2.RIGHT

#
func create_floors() -> void:
	while iteration <= amount_of_iterations:
		# check for last iteration
		if iteration == amount_of_iterations:
			print("Last iteration! Consider increasing amount_of_iterations or some room's/walkers' values!")
		# create a floor
		for walker in walkers:
			room[walker.pos.y][walker.pos.x] = 1
		# chance of destroying walker
		for i in range(walkers.size() - 1, -1, -1): # indexing walkers from last to first
			if walkers.size() > 1 and randf() < chance_walker_destoy:
				walkers.remove_at(i)
				#print("Walker destroyed! Walkers: ", walkers.size())
				break # destroy only one walker per iteration
		# chance of picking new direction
		for walker in walkers:
			if randf() < chance_walker_change_dir:
				walker.dir = rand_dir()
		# chance of spawning new walker
		for walker in walkers:
			if walkers.size() < max_walkers and randf() < chance_walker_spawn:
				walkers.append(Walker.new(walker.pos, rand_dir()))
				#print("Walker spawned! Walkers: ", walkers.size())
		# move walkers and remove from border
		for walker in walkers:
			walker.pos += walker.dir
			# clamp makes sure the value won't leave the range
			walker.pos.x = clamp(walker.pos.x, 1, room_width-2)
			walker.pos.y = clamp(walker.pos.y, 1, room_height-2)
		# check if room filled with floor enough
		if amount_of_floors() / (room_height * room_width) > percent_to_fill:
			print("Room filled!")
			break
		iteration += 1

func amount_of_floors() -> float:
	var floors: int = 0
	for row in room:
		for cell in row:
			if cell == 1:
				floors += 1
	return floors

func create_walls() -> void:
	# for every cell
	for row in range(room_height):
		for cell in range(room_width):
				# if cell is floor
				if room[row][cell] == 1:
					# for every cell around it
					for a in range (-1, 2):
						for b in range (-1, 2):
							if a == 0 and b == 0:
								continue
							# if cell is nothing - make it wall
							if room[row+b][cell+a] == 0:
								room[row+b][cell+a] = 2

func remove_single_walls() -> void:
	for row in range(1, room_height - 1):
		for cell in range(1, room_width - 1):
			if room[row][cell] == 2:
				var is_isolated = true
				for a in range(-1, 2):
					for b in range(-1, 2):
						if a == 0 and b == 0:
							continue
						if room[row+a][cell+b] == 2:
							is_isolated = false
							break
					if not is_isolated:
						break
				if is_isolated:
					#print("Found a single at ", cell, ",", row)
					room[row][cell] = 1

func fill_tilemap_from_room():
	for row in range(room_height):
		for cell in range(room_width):
			match room[row][cell]:
				1:
					tilemap.set_cell(Vector2i(cell, row), TILE_SOURCE_ID, TILE_ATLAS_FLOOR)
				2:
					tilemap.set_cell(Vector2i(cell, row), TILE_SOURCE_ID, TILE_ATLAS_WALL)
				_:
					tilemap.set_cell(Vector2i(cell, row), TILE_SOURCE_ID, TILE_ATLAS_VOID)
