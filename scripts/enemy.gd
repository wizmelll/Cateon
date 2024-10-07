extends Node2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var enemy_healthbar: Label = $ProgressBar/enemy_healthbar
#---------------------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	progress_bar.value = global.enemyBBR_health
	progress_bar.max_value = global.enemyBBR_max_health
	enemy_healthbar.text = str(global.enemyBBR_health)
