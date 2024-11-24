extends Node

var room = preload("res://scenes/room.tscn")
var player = preload("res://scenes/protag.tscn")
var dungeon_min_rooms = 8
var dungeon_max_rooms = 10
var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]  # 4 possible directions

signal room_entered(room)

func dungeon_generation():
	var dungeon = {}
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
