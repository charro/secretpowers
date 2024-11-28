extends Area2D

enum STATES { IDLE, ATTACK, SECRET_POWER, STOP }
var current_state = STATES.IDLE
var active_secret_power
@export var secret_power_checker: SecretPowerChecker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state != STATES.SECRET_POWER:
		get_input()
	
func get_input():
	var pressed_attack_key = false
	var action_pressed = null
	if Input.is_action_just_pressed("first"):
		action_pressed = "first"
		$AnimatedSprite2D.play("punch")
		print("Playing punch")
		$PunchSound.play()
		pressed_attack_key = true
	elif Input.is_action_just_pressed("second"):
		action_pressed = "second"
		$AnimatedSprite2D.play("kick")
		print("Playing kick")
		pressed_attack_key = true

	if pressed_attack_key:
		current_state = STATES.ATTACK
		get_tree().call_group("touching_player", "attacked")
	
	if action_pressed:
		var secret_power_triggered = \
			secret_power_checker.check_if_secret_power_triggered(action_pressed)
		if secret_power_triggered != null:
			trigger_secret_power(secret_power_triggered)
		
func _on_animation_finished() -> void:
	active_secret_power = null
	$AnimatedSprite2D.animation = "idle"
	current_state = STATES.IDLE
 
func _on_player_area_entered(enemy: Area2D) -> void:
	enemy.add_to_group("touching_player")

func _on_player_area_exited(enemy: Area2D) -> void:
	enemy.remove_from_group("touching_player")

func stop():
	current_state = STATES.STOP

func move():
	current_state = STATES.IDLE

func trigger_secret_power(secret_power_id: SecretPowerChecker.SECRET_POWERS):
	active_secret_power = secret_power_id
	match secret_power_id:
		SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
			megapunch()

func megapunch():
	print("Animate Megapunch")
	# Apply multi attack
	$AnimatedSprite2D.play("megapunch")
	$PunchSound.play()
	current_state = STATES.SECRET_POWER

func _on_animated_sprite_2d_frame_changed() -> void:
	# Hit the enemies in each frame
	if active_secret_power == SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
		get_tree().call_group("touching_player", "attacked")
