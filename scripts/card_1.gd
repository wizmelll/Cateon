extends Node2D

var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				global.enemyBBR_health = global.enemyBBR_health - 5
				print(global.enemyBBR_health)
				queue_free()
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.1, 1.1)

func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)

func _on_area_2d_body_entered(body:StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body

func _on_area_2d_body_exited(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false