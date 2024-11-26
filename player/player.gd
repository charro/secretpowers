extends Area2D

enum STATES { IDLE, ATTACK, STOP }

var current_state = STATES.IDLE

var active_secret_power

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == STATES.IDLE:
		get_input()
	
func get_input():
	var pressed_attack_key = false
	if Input.is_action_just_pressed("first"):
		$AnimatedSprite2D.play("punch")
		$PunchSound.play()
		pressed_attack_key = true
	elif Input.is_action_just_pressed("second"):
		$AnimatedSprite2D.play("kick")
		pressed_attack_key = true

	if pressed_attack_key:
		current_state = STATES.ATTACK
		get_tree().call_group("touching_player", "attacked")

		
func _on_animation_finished() -> void:
	active_secret_power = null
	$AnimatedSprite2D.animation = "idle"
	if current_state == STATES.ATTACK:
		current_state = STATES.IDLE
 
func _on_player_area_entered(enemy: Area2D) -> void:
	enemy.add_to_group("touching_player")

func _on_player_area_exited(enemy: Area2D) -> void:
	enemy.remove_from_group("touching_player")

func stop():
	current_state = STATES.STOP

func move():
	current_state = STATES.IDLE

func secret_power(secret_power_id: SecretPowerChecker.SECRET_POWERS):
	active_secret_power = secret_power_id
	match secret_power_id:
		SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
			megapunch()

func megapunch():
	# Apply multi attack
	$AnimatedSprite2D.play("megapunch")
	$PunchSound.play()
	current_state == STATES.ATTACK

func _on_animated_sprite_2d_frame_changed() -> void:
	# Hit the enemies in each frame
	if active_secret_power == SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
		get_tree().call_group("touching_player", "attacked")
