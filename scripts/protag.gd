extends CharacterBody2D
const speed = 50
@onready var animation_player = $AnimationPlayer
#---------------------------------------------------------------------------------------------------
#eine Funktion, die die Bewegung des Spielers anhand vom Input bestimmen wird
func _movement():
	var direction = Input.get_vector("left", "right", "up", "down") #vektoriale Richtung vom Spielerinput bestimmen
	#das folgende if/elif statement wird die Bewegung des Spielers auf 4 Achsen beschränken
	if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		direction.x = 0
	elif Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		direction.y = 0
	direction = direction.normalized() #nimmt Vektor und waldenlt es in elementar um
	velocity = direction * speed
#---------------------------------------------------------------------------------------------------
#eine Funktion, die die velocity von der movement Funktion herausholt um passende animationen abzuspielen
func _animation_player():
	if velocity == Vector2(0, 0):
		animation_player.stop()
	else:
		var walkDirection = "D"
		if velocity.x < 0:
			walkDirection = "L"
		if velocity.x > 0:
			walkDirection = "R"
		if velocity.y < 0:
			walkDirection = "U"
		animation_player.play("walk" + walkDirection)
#---------------------------------------------------------------------------------------------------
#die physics process Funktion von Godot ist eine, die ständig updated
func _physics_process(_delta):
	_movement()
	move_and_slide()
	_animation_player()
