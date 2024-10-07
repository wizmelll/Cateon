extends Node
#---------------------------------------------------------------------------------------------------
#Karten für Array
const CARD_1 = preload("res://scenes/card_1.tscn")
const CARD_2 = preload("res://scenes/card_2.tscn")
#---------------------------------------------------------------------------------------------------
#player Variabeln
var is_dragging = false
var player_health = 15
var player_max_health = 15
var player_shield = 0
var player_mana = 3
var player_max_mana = 3
var damage_multiplier = 1
var player_deck = [CARD_1, CARD_1, CARD_1, CARD_1, CARD_1, CARD_2, CARD_2, CARD_2, CARD_2]
var current_deck = []
var player_hand: Array[Node2D] = []
var player_graveyard = []
#---------------------------------------------------------------------------------------------------
#blueBootsRat
var enemyBBR_health = 40
var enemyBBR_max_health = 40
var enemyBBR_damage_min = 5
var enemyBBR_damage_max = 8
