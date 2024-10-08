extends Node2D
var random = RandomNumberGenerator.new()
var damage
#---------------------------------------------------------------------------------------------------
var cards_to_draw
var new_card
#---------------------------------------------------------------------------------------------------
#labels
@onready var health: Label = $CanvasLayer/TextboxUp/health
@onready var shieldbar: Label = $CanvasLayer/TextboxUp/shieldbar
@onready var manabar_2: Label = $CanvasLayer/TextboxUp/manabar2
@onready var end_turn_button: Button = $"end turn button"
@onready var enemy_action: Label = $Thinking/enemy_action
#---------------------------------------------------------------------------------------------------
#hand
@onready var hand: Node2D = $CanvasLayer/Hand
@onready var cardslot_1: StaticBody2D = $cardslot1
@onready var cardslot_2: StaticBody2D = $cardslot2
@onready var cardslot_3: StaticBody2D = $cardslot3
@onready var cardslot_4: StaticBody2D = $cardslot4

#---------------------------------------------------------------------------------------------------

func _ready() -> void:
	#Schaden von Gegner berechnen
	random.randomize()
	damage = random.randi_range(global.enemyBBR_damage_min, global.enemyBBR_damage_max)
	#Deck und Hand laden
	global.current_deck = global.player_deck.duplicate()
	global.player_hand = []
	global.current_deck.shuffle()
	draw_cards()
	current_hand()
func _physics_process(delta: float) -> void: 
	#setzen von verschiedene Labels
	player_health(global.player_health, global.player_max_health)
	player_shield(global.player_shield)
	player_mana(global.player_mana, global.player_max_mana)
	enemy_next_action(damage)
#---------------------------------------------------------------------------------------------------
#label managemant
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
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
	elif global.player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
#---------------------------------------------------------------------------------------------------
# cards management
func current_hand():
		global.player_hand[0].position = cardslot_1.position - Vector2(16, 24)
		global.player_hand[1].position = cardslot_2.position - Vector2(16, 24)
		global.player_hand[2].position = cardslot_3.position - Vector2(16, 24)
		global.player_hand[3].position = cardslot_4.position - Vector2(16, 24)

func draw_cards():
	global.player_hand = []
	for n in 4:
		new_card = global.current_deck.pick_random().instantiate()
		global.player_hand.push_front(new_card)
		print(global.current_deck)
		print("#---------------------------------------------------------------------------------------------------")
		global.current_deck.erase(new_card)
		print(global.current_deck)
		hand.add_child(new_card)

func refresh_deck():
	if global.current_deck.size() <= cards_to_draw:
		pass
#---------------------------------------------------------------------------------------------------
#end turn button -> nächsten Zug starten
func _on_end_turn_button_pressed():
	if global.player_shield == 0:
		global.player_health = global.player_health - damage
	elif global.player_shield - damage < 0:
		global.player_shield = global.player_shield - damage
		global.player_health = global.player_health + global.player_shield
		global.player_shield = 0
	else:
		global.player_shield = global.player_shield - damage
	random.randomize()
	damage = random.randi_range(global.enemyBBR_damage_min, global.enemyBBR_damage_max)
	global.player_mana = global.player_max_mana
	draw_cards()
	current_hand()
