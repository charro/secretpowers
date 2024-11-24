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

func hide_pop_ups():
	$GameOver.visible = false
	$NewSecretPowerPanel.visible = false
	$SecretPowerFound.visible = false

func update_cooldown_time(remaining_time):
	var remaining_time_in_secs = int(remaining_time) + 1
	$CooldownTime.visible = true
	$CooldownTime.text = "POWERS COOLDOWN: " + str(remaining_time_in_secs)

func hide_cooldown():
	$CooldownTime.visible = false

func new_secret_power_found(keys_to_trigger_power):
	$SecretPowerFound.visible = true
	$SecretPowerFound.show_keys_combination(keys_to_trigger_power)

func level_up(new_max_points: int, keys_for_unblocked_power):
	$NewSecretPowerPanel.visible = true
	$NewSecretPowerPanel.show_keys_combination(keys_for_unblocked_power)
	$ProgressBar.max_value = new_max_points
	$ProgressBar.value = 0
