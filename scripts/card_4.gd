extends Node2D

# Card properties
var card_cost = 2
var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2

@onready var description: Label = $"../description"

#---------------------------------------------------------------------------------------------------
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
			if is_inside_dropable and global.player_mana >= card_cost:
				description.text = ""

				# Card effect: Add shield
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				tween.bind_node(self)
				global.player_shield += 6
				global.player_latent_shield += 6
				global.player_mana -= card_cost

				#global.player_graveyard.append(self)
				global.player_hand.erase(self)

				queue_free()
			else:
				description.text = ""
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				tween.bind_node(self)

func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.1, 1.1)
		description.text = """crown
		-------------
		gain 6 shield
		for 2 turns"""

func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
		description.text = ""

func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body

func _on_area_2d_body_exited(body: StaticBody2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
