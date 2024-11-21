extends Node2D
class_name SecretPowerChecker

const MAX_TIME_FOR_CHECK = 1 #seconds
enum ACTION_KEYS { FIRST, SECOND, THIRD, FOURTH }
enum SECRET_POWER { MEGA_PUNCH }
var first_power = [ACTION_KEYS.FIRST, ACTION_KEYS.FIRST, ACTION_KEYS.FIRST]
var current_actions_sequence = []
var accumulated_time_since_last_check = 0
var is_cooldown_active = false

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
			new_action_pressed(ACTION_KEYS.FIRST)
		
func new_action_pressed(action: ACTION_KEYS):
	current_actions_sequence.append(action)
	if current_actions_sequence == first_power:
		power_triggered(SECRET_POWER.MEGA_PUNCH)
		
func power_triggered(secret_power: SECRET_POWER):
	get_tree().call_group("touching_player", "secret_power", str(secret_power))
	current_actions_sequence.clear()
	accumulated_time_since_last_check = 0
	$CooldownTimer.start()
	is_cooldown_active = true

func _on_cooldown_timer_timeout() -> void:
	is_cooldown_active = false
	$"../UI".hide_cooldown()
