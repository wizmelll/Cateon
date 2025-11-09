extends Node

var room = preload("res://scenes/room.tscn")

const START_BATTLE = preload("uid://fy05ly3e33ak")
const START_BATTLE_2 = preload("uid://lhhon62mhrko")
const START_BATTLE_3 = preload("uid://baj0tyedxw0yh")
var enemy_array = [START_BATTLE, START_BATTLE_2, START_BATTLE_3]

var choosen_enemies
var enemy_spawn
var dungeon_min_rooms = 8
var dungeon_max_rooms = 11
var order = 1
var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

func dungeon_generation():
	var dungeon = {}
	var enemies = {}
	var doors = {}
	var dungeon_size = randi_range(dungeon_min_rooms, dungeon_max_rooms)
	var starting_room = room.instantiate()
	dungeon[Vector2(0, 0)] = starting_room
	dungeon_size -= 1
	while dungeon_size > 0:
		for room_pos in dungeon.keys():
			var random_dir = directions[randi_range(0, directions.size() - 1)]
			var new_room_pos = room_pos + random_dir
			if !dungeon.has(new_room_pos):  # Only create a room if it doesn't exist
				var new_room = room.instantiate()
				new_room.position.x = room_pos.x * 160
				new_room.position.y = room_pos.y * 144
				dungeon[new_room_pos] = new_room
				dungeon_size -= 1
				doors[new_room_pos] = connect_rooms(dungeon[room_pos], new_room, random_dir)
				choose_enemy()
				var new_enemy = enemy_spawn.instantiate()
				enemies[new_room_pos] = new_enemy
				if dungeon_size <= 0:
					break
	return {
	"dungeon": dungeon,
	"enemies": enemies,
}

func connect_rooms(roomA, roomB, direction):
	roomA.connect_door(direction)
	roomB.connect_door(-direction)
	roomA.open_doors[direction] = true
	roomB.open_doors[-direction] = true

func choose_enemy():
	var number = randi_range(0, 2)
	enemy_spawn = enemy_array[number]
