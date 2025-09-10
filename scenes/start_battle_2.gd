extends Area2D
func _on_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/combat2.tscn") # wechselt dungeon szene zu combat szene
	global.enemyBER_health = global.enemyBER_max_health
	global.player_health = global.player_max_health
	global.player_mana = global.player_max_mana
	queue_free()
#---------------------------------------------------------------------------------------------------
#to-do: save player position
