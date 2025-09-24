extends Node2D
@onready var room_node: Node2D = $"room_node"
@onready var map_node = $map
@onready var player_node: Node2D = $player_container  # Ensure the scene has a dedicated container for the player

@export var player = PLAYER.instantiate()

const ROOM = preload("res://scenes/room.tscn")
const PLAYER = preload("res://scenes/protag.tscn")

func _ready():
	if global.need_dungeon:
		randomize()
		global.dungeon = DungeonGen.dungeon_generation()
		save_dungeon_state()
		global.need_dungeon = false
	else:
		global.dungeon = {}
	for room_pos in global.store_dungeon.keys():
		var new_room = ROOM.instantiate()
		global.dungeon[room_pos] = new_room
	load_map()
	
func load_map():
	# Generate dungeon
	for room_pos in global.dungeon.keys():
		var new_room = global.dungeon[room_pos]
		map_node.add_child(new_room)
		new_room.position.x = room_pos.x * 256
		new_room.position.y = room_pos.y * 144

		# Close or connect doors
		for direction in DungeonGen.directions:
			if !global.dungeon.has(room_pos + direction):
				new_room.close_door(direction)
			else:
				new_room.connect_door(direction)

	# Place player in the starting room
	var starting_room = global.dungeon[Vector2(0, 0)]
	starting_room.add_child(player)
	player.position = Vector2(128, 120)  # Player's initial position
	player.z_index += 3
	
	# Save the current scene (or dungeon)
	save_dungeon_state()
	
	# Spawn enemies

func save_dungeon_state():
	# Save the current dungeon to a global variable
	global.store_dungeon = {}  # Reset stored dungeon
	for room_pos in global.dungeon.keys():
		var room_data = {
			"position": room_pos,
			"state": global.dungeon[room_pos]
		}
		global.store_dungeon[room_pos] = room_data
