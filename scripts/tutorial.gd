extends Node2D

var text = ""
var current = 0

func _ready() -> void:
	tutorial_text()

func _process(delta: float) -> void:
	input()
	choose_text()
	tutorial_text()

func tutorial_text():
	$"bot textbox".show()
	$"bot textbox/Label2".text = text

func input():
	if Input.is_action_just_pressed("right") and $"bot textbox".visible:
		current += 1
	if Input.is_action_just_pressed("left") and $"bot textbox".visible and current != 0:
		current -= 1
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	

func choose_text():
	if current == 0:
		text = "use the a/← and d/→ keys to continue with the tutorial"
		$full.hide()
		$dungeon.hide()
		
	if current == 1:
		text = "Welcome to Cateon, a roguelike deckbuilder game."
		$dungeon.show()
		
	if current == 2:
		text = "The goal of this game is to traverse the dungeon using
		the wasd/↑←↓→ keys and exterminate all the rats."
		$dungeon.show()
		$full.hide()
	if current == 3:
		text = "now onto the combat..."
		$full.show()
		$top.hide()
		$dungeon.hide()
		
	if current == 4:
		text = "On top you can see the player's life, shield and mana."
		$top.show()
		$full.hide()
		
	if current == 5:
		text = "If you lifepoints reach 0 you'll have to restart the
		game from the beginning..."
		
	if current == 6:
		text = "...shield is gained through certain cards and reduces
		the damage that rats deal to you..."
		
	if current == 7:
		text = "...and mana is the resource used to play cards. 
		You gain your mana back after every turn."
		$top.show()
		$bot.hide()
		
	if current == 8:
		text = "At the bottom you can see the cards in your hand and 
		an end turn button."
		$bot.show()
		$top.hide()
		
	if current == 9:
		text = "if you hover you mouse over a card its description 
		will be shown on the textbox to the left"
		
	if current == 10:
		text = "to play a card you require its mana cost, which is
		shown at the top of each card..."
		
	if current == 11:
		text = "...and then drag and drop it over the enemy you want
		to attack. The same goes for shield cards."
		$bot.show()
		$mid.hide()
		
	if current == 12:
		text = "After you end your turn, you will be attacked by the rat."
		$mid.show()
		$bot.hide()
		
	if current == 13:
		text = "the damge that will be dealt to you is shown next to the rat
		in the thought bubble."
		$mid.show()
		
	if current == 14:
		text = "I hope you enjoy your experience with Cateon!"
		$mid.hide()
		
	if current == 15:
		text = ""
		current = 0
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	#match!!!
