extends Node2D
var random = RandomNumberGenerator.new()
var damage
@onready var health: Label = $CanvasLayer/TextboxUp/health
@onready var shieldbar: Label = $CanvasLayer/TextboxUp/shieldbar
@onready var manabar_2: Label = $CanvasLayer/TextboxUp/manabar2
@onready var end_turn_button: Button = $"end turn button"
@onready var enemy_action: Label = $Thinking/enemy_action
#---------------------------------------------------------------------------------------------------
func _ready() -> void:
	random.randomize()
	damage = random.randi_range(global.enemyBBR_damage_min, global.enemyBBR_damage_max)
	print(str(damage))
func _physics_process(delta: float) -> void: #setzen von verschiedene Labels
	player_health(global.player_health, global.player_max_health)
	player_shield(global.player_shield)
	player_mana(global.player_mana, global.player_max_mana)
	enemy_next_action(damage)

func player_health(player_health, player_max_health):
	health.text = "%d/%d" % [player_health, player_max_health]

func player_shield(player_shield):
	shieldbar.text = str(player_shield)

func player_mana(player_mana, player_max_mana):
	manabar_2.text = "%d/%d" % [player_mana, player_max_mana]

func enemy_next_action(damage):
	enemy_action.text = str(damage)
#---------------------------------------------------------------------------------------------------
#check für Tode
func _process(delta: float) -> void:
	if global.enemyBBR_health <= 0:
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn") # wechselt dungeon szene zu combat szene
	elif global.player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
#---------------------------------------------------------------------------------------------------
#end turn button
func _on_end_turn_button_pressed():
	global.player_health = global.player_health - damage
	global.player_mana = global.player_max_mana
	random.randomize()
	damage = random.randi_range(global.enemyBBR_damage_min, global.enemyBBR_damage_max)
