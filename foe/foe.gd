extends Area2D

@export var max_velocity: float = 200
@export var max_life: int = 5

var velocity: float
var life: int

enum STATES { MOVE, STOP } 

var current_state

signal killed
signal survived

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life = max_life
	velocity = max_velocity
	move()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == STATES.MOVE:
		position.x = position.x - velocity * delta
	check_if_survived()

func attacked():
	life = clampi(life - 1, 0, max_life)
	velocity = clampf(velocity * 0.7, 0, max_velocity)
	position.x = position.x + 10
	$AnimationPlayer.play("attacked")
	if life == 0:
		queue_free()
		killed.emit()

func stop():
	current_state = STATES.STOP
	
func move():
	current_state = STATES.MOVE

func check_if_survived():
	if position.x < 0:
		survived.emit()
		queue_free()

func secret_power(power: SecretPowerChecker.SECRET_POWER):
	if power == SecretPowerChecker.SECRET_POWER.MEGA_PUNCH:
		queue_free()
