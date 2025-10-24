extends Camera2D

#Kamera Verschiebung
func _ready():
	DungeonGen.room_entered.connect(func(room):
		global_position = room.global_position + Vector2(80, 72)
	)
