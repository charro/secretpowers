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
	$CooldownBar.value = remaining_time_in_secs

func hide_cooldown():
	$CooldownBar.value = 0

func new_secret_power_found(secret_power: SecretPowerChecker.SECRET_POWERS, keys_to_trigger_power):
	var secret_power_visible_name
	match secret_power:
		SecretPowerChecker.SECRET_POWERS.MULTI_PUNCH:
			secret_power_visible_name = "Multi Punch"
		SecretPowerChecker.SECRET_POWERS.KAMEAMEA:
			secret_power_visible_name = "Kame Hame Ha"
		SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
			secret_power_visible_name = "Mega Punch"
			
	$SecretPowerFound.visible = true
	$SecretPowerFound.show_keys_combination(keys_to_trigger_power)
	$SecretPowerFound.set_custom_label_text(secret_power_visible_name)
	$PowerFoundTimer.start()

func level_up(new_level: int, new_max_points: int, keys_for_unblocked_power):
	if keys_for_unblocked_power:
		$NewSecretPowerPanel.visible = true
		$NewSecretPowerPanel.show_keys_combination(keys_for_unblocked_power)
	$ProgressBar.max_value = new_max_points
	$ProgressBar.value = 0
	$LevelLabel.text = "Lvl " + str(new_level + 1)

func _on_power_found_timer_timeout() -> void:
	$SecretPowerFound.visible = false
