extends Camera2D

var camera_pos = global.player_position

#Kamera Verschiebung
func _ready():
	for room_pos in global.dungeon.keys():
		global.dungeon[room_pos].move_camera.connect(_move_camera)

func _move_camera(new_position):
	self.position = new_position + Vector2(80, 72)
