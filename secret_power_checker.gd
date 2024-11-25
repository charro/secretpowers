extends Node2D
class_name SecretPowerChecker

const MAX_TIME_FOR_CHECK: int = 1 #seconds
enum SECRET_POWERS { MEGA_PUNCH = 0, KAMEAMEA = 1, TORNADO = 2 }
var current_actions_sequence: Array[Variant] = []
var accumulated_time_since_last_check: float   = 0
var is_cooldown_active: bool = false

var secret_powers_unblocked: int        = 0
var secret_powers_found: Array[Variant] = []

@onready var secret_powers: Dictionary = {
	SECRET_POWERS.MEGA_PUNCH: $SecretPowers/FirstSecretPower,
	SECRET_POWERS.KAMEAMEA: $SecretPowers/SecondSecretPower,
	SECRET_POWERS.TORNADO: $SecretPowers/ThirdSecretPower
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_cooldown_active:
		$"../UI".update_cooldown_time($CooldownTimer.get_time_left())
	else:
		accumulated_time_since_last_check += delta
		
		if accumulated_time_since_last_check > MAX_TIME_FOR_CHECK:
			current_actions_sequence.clear()
			accumulated_time_since_last_check = 0
			
		if Input.is_action_just_pressed("first"):
			new_action_pressed(SecretPower.ACTION_KEYS.FIRST)
		elif Input.is_action_just_pressed("second"):
			new_action_pressed(SecretPower.ACTION_KEYS.SECOND)
		
func new_action_pressed(action: SecretPower.ACTION_KEYS):
	current_actions_sequence.append(action)
	for secret_power_index in range(0, secret_powers_unblocked):
		var secret_power = secret_powers[secret_power_index]
		if secret_power.matches(current_actions_sequence):
			power_triggered(secret_power_index)

func power_triggered(secret_power: SECRET_POWERS):
	if secret_power in secret_powers_found:
		print("SECRET POWER TRIGGERED!!:", secret_power)
		# Apply the secret power to all foes in screen
		get_tree().call_group("touching_player", "secret_power", str(secret_power))
		# Apply the secret power to player
		$"../Player".secret_power(secret_power)
		current_actions_sequence.clear()
		accumulated_time_since_last_check = 0
		$CooldownTimer.start()
		is_cooldown_active = true
	else:
		print("Secret Power Discovered!!")
		secret_powers_found.append(secret_power)
		$"../UI".new_secret_power_found(current_actions_sequence)

func _on_cooldown_timer_timeout() -> void:
	is_cooldown_active = false
	$"../UI".hide_cooldown()

func new_power_unblocked():
	secret_powers_unblocked = \
		clampi(secret_powers_unblocked + 1, 0, len(SECRET_POWERS))

func get_keys_on_secret_power(level: int):
	if level < len(SECRET_POWERS) :
		var secret_power_for_level = secret_powers[level]
		var secret_power_keys = secret_power_for_level.keys_combination
		var unique_keys: Array[Variant] = []
		for key in secret_power_keys:
			if key not in unique_keys:
				unique_keys.append(key)
		return unique_keys
	else:
		return []
