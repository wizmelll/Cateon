extends Node2D

@onready var map_node = $map
const room = preload("res://scenes/room.tscn")
const player = preload("res://scenes/protag.tscn")
const camera = preload("uid://bqod5fmhsh48o")


func _ready():
	for child in map_node.get_children():
		child.queue_free()
	if global.need_dungeon:
		var generation = dungeongeneration.dungeon_generation()
		global.dungeon = generation["dungeon"]
		global.enemies = generation["enemies"]
		save_dungeon_state()
		global.need_dungeon = false
	load_()

func load_():
	global.dungeon = {}
	for room_pos in global.store_dungeon.keys():
		var room_data = global.store_dungeon[room_pos]
		var load_node = room_data["node"]
		map_node.add_child(load_node)
		load_node.position = room_data["global_position"]
		global.dungeon[room_pos] = load_node
		if room_data.has("doors"):
			load_node.open_doors = room_data["doors"].duplicate(true)
			load_node._reload_doors()
		print("Load", room_pos, "doors:", load_node.open_doors)
	global.enemies = {}
	for room_pos in global.store_enemies.keys():
		var enemy_data = global.store_enemies[room_pos]
		var load_node = enemy_data["node"]
		var room_instance = global.dungeon[room_pos]
		room_instance.add_child(load_node)
		load_node.position = enemy_data["local_position"] + Vector2i(80, 60)
		global.enemies[room_pos] = load_node
	var starting_room = global.dungeon[Vector2(0, 0)]
	var kitty = player.instantiate()
	starting_room.add_child(kitty)
	kitty.position = global.player_position
	save_dungeon_state()
	var add_camera = camera.instantiate()
	self.add_child(add_camera)

func save_dungeon_state():
	global.store_dungeon = {}
	for room_pos in global.dungeon.keys():
		var room_node = global.dungeon[room_pos]
		global.store_dungeon[room_pos] = {
			"node": room_node,
			"global_position": room_node.global_position,
			"doors": room_node.open_doors.duplicate(true)
		}
		print("Save", room_pos, "doors:", room_node.open_doors)
	global.store_enemies = {}
	for room_pos in global.enemies.keys():
		var enemy_node = global.enemies[room_pos]
		global.store_enemies[room_pos] = {
			"node": enemy_node,
			"local_position": get_parent().position
		}

func on_enemy_down(this_enemy):
	# Find which enemy_pos this was
	for enemy_pos in global.enemies.keys():
		if global.enemies[position] == this_enemy:
			global.enemies.erase(position)
			if global.store_enemies.has(position):
				global.store_enemies.erase(position)
			break
	save_dungeon_state()
