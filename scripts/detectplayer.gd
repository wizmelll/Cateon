@tool
extends Area2D

@export var room_position = Vector2()
@export var change = false

func _process(delta: float) -> void:
	if change == true:
		position = room_position
		change = false
