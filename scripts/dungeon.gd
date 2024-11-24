extends Node2D
@onready var room_node: Node2D = $"room_node"
@onready var map_node = $map
@onready var player_node: Node2D = $player_container  # Ensure the scene has a dedicated container for the player

const ROOM = preload("res://scenes/room.tscn")
const PLAYER = preload("res://scenes/protag.tscn")
var dungeon = {}

func _ready():
	randomize()
	dungeon = DungeonGen.dungeon_generation()
	load_map()

func load_map():
	#Dungeon generieren
	for room_pos in dungeon.keys():
		var new_room = dungeon[room_pos]
		map_node.add_child(new_room)
		new_room.position.x = room_pos.x * 256
		new_room.position.y = room_pos.y * 144

		#Türen schliessen
		for direction in DungeonGen.directions:
			if !dungeon.has(room_pos + direction):
				new_room.close_door(direction)
			else:
				new_room.connect_door(direction)

	#Spieler ins Starterzimmer setzen
	var starting_room = dungeon[Vector2(0, 0)]
	var player = PLAYER.instantiate()
	starting_room.add_child(player)
	player.position = Vector2(128, 72)
	player.z_index += 3
	
	#Gegner spawnen
	
