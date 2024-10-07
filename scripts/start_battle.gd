extends Area2D
func _on_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/combat.tscn") # wechselt dungeon szene zu combat szene
	global.enemyBBR_health = global.enemyBBR_max_health
	global.player_health = global.player_max_health
#---------------------------------------------------------------------------------------------------
