extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_points(points: int):
	$ProgressBar.value = points
	
func set_life(life: int):
	$LifeBar.value = life

func show_dead():
	$GameOver.visible = true

func level_up(new_max_points: int):
	$NewSecretPowerPanel.visible = true
	$ProgressBar.max_value = new_max_points
	$ProgressBar.value = 0

func hide_pop_ups():
	$GameOver.visible = false
	$NewSecretPowerPanel.visible = false
	$SecretPowerFound.visible = false
