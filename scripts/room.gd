extends Node2D

# Dictionary mapping directions to door NodePaths
var doors = {}
@export var enemy = 1
var pick_enemy
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
	spawn_enemy()

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

func spawn_enemy():
	if enemy == 1:
		pick_enemy = randi_range(1, 3)
		if pick_enemy == 1:
			enemy_spawn = START_BATTLE.instantiate()
			(self).add_child(enemy_spawn)
			enemy_spawn.position = Vector2(128, 72)
			enemy -= 1
		elif pick_enemy == 2:
			enemy_spawn = START_BATTLE_2.instantiate()
			(self).add_child(enemy_spawn)
			enemy_spawn.position = Vector2(128, 72)
			enemy -= 1
		elif pick_enemy ==3:
			enemy_spawn = START_BATTLE_3.instantiate()
			(self).add_child(enemy_spawn)
			enemy_spawn.position = Vector2(128, 72)
			enemy -= 1
	else:
		pass
