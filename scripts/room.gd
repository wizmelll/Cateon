extends Node2D

# Dictionary mapping directions to door NodePaths
var doors = {}
var pos = self.position
@export var enemy = 0
var enemy_spawn
@onready var camera_2d: Camera2D = $Camera2D
const START_BATTLE = preload("uid://fy05ly3e33ak")
const START_BATTLE_2 = preload("uid://lhhon62mhrko")
const START_BATTLE_3 = preload("uid://baj0tyedxw0yh")

func _ready():
	# Initialize door references
	doors[Vector2(1, 0)] = get_node("door_right")
	doors[Vector2(-1, 0)] = get_node("door_left")
	doors[Vector2(0, 1)] = get_node("door_down")
	doors[Vector2(0, -1)] = get_node("door_up")

func connect_door(direction):
	if doors.has(direction) and doors[direction] != null:
		doors[direction].queue_free()
		doors[direction] = null
	else:
		pass

func close_door(direction):
	if doors.has(direction) and doors[direction] != null:
		doors[direction].visible = true  # Close the door
	else:
		pass

func _on_detect_body_entered(body: Node2D) -> void:
	DungeonGen.room_entered.emit(self)
	
