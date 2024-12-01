extends Area2D

enum STATES { IDLE, ATTACK, SECRET_POWER, STOP }
var current_state = STATES.IDLE
var active_secret_power
@export var secret_power_checker: SecretPowerChecker
var level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state not in [STATES.STOP, STATES.SECRET_POWER]:
		get_input()

func get_input():
	var pressed_attack_key = false
	var action_pressed     = null
	if Input.is_action_just_pressed("first"):
		action_pressed = "first"
		$AnimatedSprite2D.play("punch")
		$PunchSound.play()
		pressed_attack_key = true
	elif Input.is_action_just_pressed("second") and level > 1:
		action_pressed = "second"
		$AnimatedSprite2D.play("kick")
		pressed_attack_key = true
	elif Input.is_action_just_pressed("third") and level > 2:
		action_pressed = "third"

	if pressed_attack_key:
		current_state = STATES.ATTACK
		get_tree().call_group("touching_player", "attacked")
		
	if action_pressed:
		secret_power_checker.check_if_secret_power_triggered(action_pressed)
			
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
	$AnimatedSprite2D.stop()

func move():
	current_state = STATES.IDLE

func _on_animated_sprite_2d_frame_changed() -> void:
	# Hit the enemies in each frame if MultiPunching
	if active_secret_power == SecretPowerChecker.SECRET_POWERS.MULTI_PUNCH:
		get_tree().call_group("touching_player", "secret_power", active_secret_power)


func _on_secret_power_checker_secret_power_triggered(secret_power_id: SecretPowerChecker.SECRET_POWERS) -> void:
	active_secret_power = secret_power_id
	current_state = STATES.SECRET_POWER
	match secret_power_id:
		SecretPowerChecker.SECRET_POWERS.MULTI_PUNCH:
			multipunch()
		SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
			megapunch()

func multipunch():
	$AnimatedSprite2D.play("multipunch")
	$PunchSound.play()

func megapunch():
	$AnimatedSprite2D.play("megapunch")
	$PunchSound.play()
	get_tree().call_group("touching_player", "secret_power", active_secret_power)
