extends Node2D

var doors = {}
var open_doors = {}
var door_changes = {}

@onready var door_up = $TileMap/door_up
@onready var door_down = $TileMap/door_down
@onready var door_left = $TileMap/door_left
@onready var door_right = $TileMap/door_right

@export var enemy = 0
var enemy_spawn
@onready var camera_2d: Camera2D = $Camera2D

signal move_camera(new_position)

func _ready():
	doors = {
		Vector2(0, -1): $TileMap/door_up,
		Vector2(0, 1): $TileMap/door_down,
		Vector2(-1, 0): $TileMap/door_left,
		Vector2(1, 0): $TileMap/door_right
	}
	
	for direction in doors.keys():
		if doors[direction]:
			door_changes[direction] = doors[direction].position
	
	if open_doors.is_empty():
		for direction in doors.keys():
			open_doors[direction] = false
	else:
		_reload_doors()

func _reload_doors():
	for direction in open_doors.keys():
		if open_doors[direction]:
			connect_door(direction)
		else:
			close_door(direction)

func connect_door(direction):
	if doors.has(direction) and doors[direction]:
		if doors[direction].is_inside_tree():
			doors[direction].queue_free()
		doors[direction] = null
		open_doors[direction] = true

func close_door(direction):
	if doors.has(direction) and doors[direction] != null:
		return
		
	var new_door
	match direction:
		Vector2(0, -1): new_door = door_up.instantiate()
		Vector2(0, 1): new_door = door_down.instantiate()
		Vector2(-1, 0): new_door = door_left.instantiate()
		Vector2(1, 0): new_door = door_right.instantiate()
		_: return
	
	if door_changes.has(direction):
		new_door.position = door_changes[direction]
	doors[direction] = new_door
	open_doors[direction] = false

func _on_detect_body_entered(_body: Node2D) -> void:
	emit_signal("move_camera", global_position)
	
