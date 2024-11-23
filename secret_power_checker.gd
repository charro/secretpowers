extends Node2D
class_name SecretPowerChecker

const MAX_TIME_FOR_CHECK = 1 #seconds
enum SECRET_POWERS { MEGA_PUNCH, KAMEAMEA }
var current_actions_sequence = []
var accumulated_time_since_last_check = 0
var is_cooldown_active = false

var secret_powers_unblocked = 0
var secret_powers_found = []

@onready var secret_powers = {
	SECRET_POWERS.MEGA_PUNCH: $FirstSecretPower,
	SECRET_POWERS.KAMEAMEA: $SecondSecretPower
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
		get_tree().call_group("touching_player", "secret_power", str(secret_power))
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
