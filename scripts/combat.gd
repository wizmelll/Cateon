extends Node2D

var random = RandomNumberGenerator.new()
var damage
var min_damage
var max_damage
var enemy_health
var enemy_max_health
var poison

#---------------------------------------------------------------------------------------------------
var new_card
#---------------------------------------------------------------------------------------------------
#labels
@onready var health: Label = $CanvasLayer/TextboxUp/health
@onready var shieldbar: Label = $CanvasLayer/TextboxUp/shieldbar
@onready var manabar_2: Label = $CanvasLayer/TextboxUp/manabar2
@onready var end_turn_button: Button = $"end turn button"
@onready var enemy_action: Label = $Thinking/enemy_action
@onready var progress_bar: ProgressBar = $enemy/ProgressBar
@onready var enemy_healthbar: Label = $enemy/ProgressBar/enemy_healthbar
#---------------------------------------------------------------------------------------------------
#hand
@onready var hand: Node2D = $CanvasLayer/Hand
@onready var cardslot_1: StaticBody2D = $cardslot1
@onready var cardslot_2: StaticBody2D = $cardslot2
@onready var cardslot_3: StaticBody2D = $cardslot3
@onready var cardslot_4: StaticBody2D = $cardslot4

@onready var sprite_1: Sprite2D = $enemy/Sprite1
@onready var sprite_2: Sprite2D = $enemy/Sprite2
@onready var sprite_3: Sprite2D = $enemy/Sprite3

func _ready() -> void:
	spawn_enemy()
	random.randomize()
	damage = random.randi_range(min_damage, max_damage)
	#Deck und Hand laden
	global.current_deck = global.player_deck.duplicate()
	global.player_hand = []
	global.player_graveyard = []
	global.current_deck.shuffle()
	draw_cards()
	current_hand()

func spawn_enemy():
	sprite_1.visible = false
	sprite_2.visible = false
	sprite_3.visible = false
	if global.what_enemy == 1:
		min_damage = global.enemyBBR_damage_min
		max_damage = global.enemyBBR_damage_max
		enemy_max_health = global.enemyBBR_max_health
		enemy_health = enemy_max_health
		poison = 0
		sprite_1.visible = true
		global.what_enemy = 0
	elif global.what_enemy == 2:
		min_damage = global.enemyBER_damage_min
		max_damage = global.enemyBER_damage_max
		enemy_max_health = global.enemyBER_max_health
		enemy_health = enemy_max_health
		poison = 0
		sprite_2.visible = true
		global.what_enemy = 0
	elif global.what_enemy == 3:
		min_damage = global.enemyBTR_damage_min
		max_damage = global.enemyBTR_damage_max
		enemy_max_health = global.enemyBTR_max_health
		enemy_health = enemy_max_health
		poison = 0
		sprite_3.visible = true
		global.what_enemy = 0
	

func _card_damage(damage):
	enemy_health -= damage
func _card_poison(poison):
	global.player_shield += poison

func _process(_delta: float) -> void: 
	#setzen von verschiedene Labels
	player_mana(global.player_mana, global.player_max_mana)
	current_health(enemy_health)
	for card in global.player_hand:
		card.card_damage.connect(_card_damage)
		card.card_poison.connect(_card_poison)
	if enemy_health <= 0:
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
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

func current_health(enemy_health):
	enemy_healthbar.text = str(enemy_health)
	progress_bar.value = enemy_health
	progress_bar.max_value = enemy_max_health
#---------------------------------------------------------------------------------------------------
#Karten Management
func draw_cards():
	#refresh_deck()
	for i in range(4):
		var card_scene = global.current_deck.pick_random()
		if card_scene == null:
			continue
		var new_card = card_scene.instantiate()
		if new_card != null:
			global.player_hand.append(new_card)
			#global.current_deck.erase(card_scene)
			hand.add_child(new_card)
			new_card.position = cardslot_position(i) - Vector2(16, 24)

func refresh_deck():
	if global.current_deck.size() < 5:
		if global.player_graveyard.size() > 0:
			for card in global.player_graveyard:
				global.current_deck.append(card)
			global.player_graveyard.clear()
			global.current_deck.shuffle()


func current_hand():
	# Position the cards in the player's hand
	for i in range(len(global.player_hand)):
		global.player_hand[i].position = cardslot_position(i) - Vector2(16, 24)
	for card in global.player_hand:
		card.card_damage.connect(_card_damage)
		card.card_poison.connect(_card_poison)

func cardslot_position(index: int) -> Vector2:
	match index:
		0:
			return cardslot_1.position
		1:
			return cardslot_2.position
		2:
			return cardslot_3.position
		3:
			return cardslot_4.position
		_:
			return Vector2(-200,-200)
#---------------------------------------------------------------------------------------------------
#Zug beenden
func _on_end_turn_button_pressed():
	if global.player_shield == 0:
		global.player_health -= damage
	elif global.player_shield - damage < 0:
		global.player_shield = global.player_shield - damage
		global.player_health = global.player_health + global.player_shield
		global.player_shield = 0
	else:
		global.player_shield -= damage
		
	if global.player_health <= 0:
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
		
	global.player_shield = 0
	if global.player_latent_shield > 0:
		global.player_shield += global.player_latent_shield
		global.player_latent_shield = 0
	global.player_mana = global.player_max_mana
	
	if poison > 0:
		enemy_health -= poison
		poison -= 1
		
	random.randomize()
	damage = random.randi_range(min_damage, max_damage)
	draw_cards()
	current_hand()
	player_health(global.player_health, global.player_max_health)
	player_shield(global.player_shield)
	enemy_next_action(damage)
