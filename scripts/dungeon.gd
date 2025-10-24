extends Node2D

const ROOM = preload("res://scenes/room.tscn")
const PLAYER = preload("res://scenes/protag.tscn")

@onready var room_node: Node2D = $"room_node"
@onready var map_node = $map
@onready var player_node: Node2D = $player_container  # Ensure the scene has a dedicated container for the player

func _ready():
	if global.need_dungeon:
		global.dungeon = DungeonGen.dungeon_generation()
		save_dungeon_state()
		global.need_dungeon = false
	else:
		global.dungeon = {}
	for room_pos in global.store_dungeon.keys():
		var new_room = ROOM.instantiate()
		global.dungeon[room_pos] = new_room
	
	if global.need_enemies:
		global.enemies = DungeonGen.enemy_needed()
		save_enemies()
		global.need_enemies = false
	else:
		global.enemies = {}
	for enemy_pos in global.store_enemies:
		var new_enemy = DungeonGen.enemy_spawn
		global.enemies[enemy_pos] = new_enemy
		
	load_()
	
func load_():
	for room_pos in global.dungeon.keys():
		var new_room = global.dungeon[room_pos]
		map_node.add_child(new_room)
		new_room.position.x = room_pos.x * 160
		new_room.position.y = room_pos.y * 144
		for direction in DungeonGen.directions:
			if !global.dungeon.has(room_pos + direction):
				new_room.close_door(direction)
			else:
				new_room.connect_door(direction)
	
	var starting_room = global.dungeon[Vector2(0, 0)]
	var player = PLAYER.instantiate()
	starting_room.add_child(player)
	player.position = global.player_position
	player.z_index += 3
	
	for room_pos in global.enemies.keys():
		var spawn_enemy = global.enemies[room_pos].instantiate()
		print(spawn_enemy)
		var this_room = global.dungeon[room_pos]
		print(this_room)
		this_room.add_child(spawn_enemy)
		spawn_enemy.position.x = room_pos.x * 160
		spawn_enemy.position.y = room_pos.y * 144
		spawn_enemy.enemy_down.connect(on_enemy_down)
	
	save_dungeon_state()
	save_enemies()

func save_dungeon_state():
	global.store_dungeon = {}
	for room_pos in global.dungeon.keys():
		var room_data = {
			"position": room_pos,
			"state": global.dungeon[room_pos]
		}
		global.store_dungeon[room_pos] = room_data

func save_enemies():
	global.store_enemies = {}
	for room_pos in global.enemies.keys():
		var enemy_data = {
			"position": room_pos,
			"state": global.enemies[room_pos]
		}
		global.store_enemies[room_pos] = enemy_data

func on_enemy_down(this_enemy):
	# Find which enemy_pos this was
	for position in global.enemies.keys():
		if global.enemies[position] == this_enemy:
			global.enemies.erase(position)
			if global.store_enemies.has(position):
				global.store_enemies.erase(position)
			break
	save_enemies()
