extends Node
#---------------------------------------------------------------------------------------------------
#Karten für Array
const CARD_1 = preload("res://scenes/card_1.tscn")
const CARD_2 = preload("res://scenes/card_2.tscn")
const CARD_3 = preload("res://scenes/card_3.tscn")
const CARD_4 = preload("res://scenes/card_4.tscn")
const CARD_5 = preload("res://scenes/card_5.tscn")
const CARD_6 = preload("res://scenes/card_6.tscn")
#---------------------------------------------------------------------------------------------------
#player Variabeln
var player_position = Vector2(80, 90)
var is_dragging = false
var player_health = 15
var player_max_health = 15
var player_shield = 0
var player_latent_shield = 0
var player_strenght = 0
var player_mana = 3
var player_max_mana = 3
var damage_multiplier = 1
var player_deck = [CARD_1, CARD_1, CARD_1, CARD_1, CARD_1, CARD_2, CARD_2, CARD_2]
var current_deck = []
var player_hand: Array[Node2D] = []
var player_graveyard = []
#---------------------------------------------------------------------------------------------------
#blueBootsRat
var enemyBBR_health = 10
var enemyBBR_max_health = 10
var enemyBBR_damage_min = 5
var enemyBBR_damage_max = 8
var enemyBBR_poison = 0
#birEarsRat
var enemyBER_health = 25
var enemyBER_max_health = 25
var enemyBER_damage_min = 3
var enemyBER_damage_max = 6
var enemyBER_poison = 0
#bigTailRat
var enemyBTR_health = 25
var enemyBTR_max_health = 25
var enemyBTR_damage_min = 3
var enemyBTR_damage_max = 6
var enemyBTR_poison = 0
#dungeon 
var need_dungeon = true
var dungeon
var store_dungeon
var need_enemies = true
var enemies
var store_enemies
var enemy_number = 0
var what_enemy
