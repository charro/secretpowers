extends Area2D

enum STATES { IDLE, ATTACK, STOP }

var current_state = STATES.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == STATES.IDLE:
		get_input()
	
func get_input():	
	if Input.is_action_just_pressed("first"):
		$AnimatedSprite2D.play("punch")
		current_state = STATES.ATTACK
		get_tree().call_group("touching_player", "attacked")
		$PunchSound.play()
		
func _on_animation_finished() -> void:
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
