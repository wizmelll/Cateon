extends Node

var room = preload("res://scenes/room.tscn")
const START_BATTLE = preload("uid://fy05ly3e33ak")
const START_BATTLE_2 = preload("uid://lhhon62mhrko")
const START_BATTLE_3 = preload("uid://baj0tyedxw0yh")

var  choosen_enemies
var enemy_spawn
var dungeon_min_rooms = 8
var dungeon_max_rooms = 11
var rooms
var order = 1
var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]  # 4 possible directions
var number_of_rooms

signal room_entered(room)

func dungeon_generation():
	var dungeon = {}
	var dungeon_size = randi_range(dungeon_min_rooms, dungeon_max_rooms)
	rooms = dungeon_size - 1
	var starting_room = room.instantiate()
	dungeon[Vector2(0, 0)] = starting_room
	dungeon_size -= 1
	while dungeon_size > 0:
		for room_pos in dungeon.keys():
			var random_dir = directions[randi_range(0, directions.size() - 1)]
			var new_room_pos = room_pos + random_dir
			if !dungeon.has(new_room_pos):  # Only create a room if it doesn't exist
				var new_room = room.instantiate()
				dungeon[new_room_pos] = new_room
				dungeon_size -= 1
				# Ensure both rooms know about their connections
				connect_rooms(dungeon[room_pos], new_room, random_dir)
				if dungeon_size <= 0:
					break
	return dungeon

func connect_rooms(roomA, roomB, direction):
	roomA.connect_door(direction)
	roomB.connect_door(-direction)

func enemy_needed():
	var enemies = {}
	while rooms != global.enemy_number:
		for room_pos in global.dungeon.keys():
			if !enemies.has(room_pos):
				var this_room = global.dungeon[room_pos]
				choose_enemy()
				var new_enemy = enemy_spawn.instantiate()
				this_room.add_child(new_enemy)
				new_enemy.position = Vector2(80, 30) #80/72
				enemies[room_pos] = new_enemy
				global.enemy_number += 1
				if rooms == global.enemy_number:
					break
	return enemies

func choose_enemy():
	var pick_enemy = randi_range(1, 3)
	if pick_enemy == 1:
		enemy_spawn = START_BATTLE
	elif pick_enemy == 2:
		enemy_spawn = START_BATTLE_2
	elif pick_enemy ==3:
		enemy_spawn = START_BATTLE_3
