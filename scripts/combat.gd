extends Node2D
@onready var health: Label = $CanvasLayer/TextboxUp/health
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var enemy_healthbar: Label = $ProgressBar/enemy_healthbar


func _ready() -> void: #Funktionen unterhalb laufen ein Mal nach dem start direkt ab
	player_health(global.player_health, global.player_max_health)
	enemy_health(global.enemyBBR_health)

func player_health(player_health, player_max_health):
	health.text = "%d/%d" % [player_health, player_max_health]

func enemy_health(enemyBBR_health):
	#enemy_healthbar.text = str(enemyBBR_health)
	pass

func _process(delta: float) -> void:
	if global.enemyBBR_health == 0:
		global.enemyBBR_health = 20
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn") # wechselt dungeon szene zu combat szene
