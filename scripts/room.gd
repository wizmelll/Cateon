extends Node2D

var doors = {}
var open_doors = {}
@export var enemy = 0
var enemy_spawn
@onready var camera_2d: Camera2D = $Camera2D
const START_BATTLE = preload("uid://fy05ly3e33ak")
const START_BATTLE_2 = preload("uid://lhhon62mhrko")
const START_BATTLE_3 = preload("uid://baj0tyedxw0yh")

signal move_camera(new_position)

func _ready():
	doors = {
		"Vector2(1, 0)" = $TileMap/door_right,
		"[Vector2(-1, 0)]" = $TileMap/door_left,
		"[Vector2(0, 1)]" = $TileMap/door_down,
		"[Vector2(0, -1)" = $TileMap/door_up
	}
	if open_doors.is_empty():
		for open in open_doors.keys():
			open_doors[open] = false
	else:
		_load_doors()

func _load_doors():
	for open in open_doors.keys():
		if open_doors[open]:
			connect_door(open)
		else:
			close_door(open)

func connect_door(direction):
	if doors.has(direction) and doors[direction] != null:
		doors[direction].visible = false
	open_doors[direction] = true

func close_door(direction):
	if doors.has(direction) and doors[direction] != null:
		doors[direction].visible = false
	open_doors[direction] = false

func _on_detect_body_entered(_body: Node2D) -> void:
	var room_position = global_position
	emit_signal("move_camera", room_position)
	
