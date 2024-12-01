extends Area2D
class_name Foe

@export var max_velocity: float = 200
@export var max_life: int = 5

var type = "foe"
var velocity: float
var life: int

enum STATES { MOVE, STOP } 

var current_state

signal killed(this: Foe)
signal survived(this: Foe)
signal megapunched(this: Foe)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life = max_life
	velocity = max_velocity
	move()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == STATES.MOVE:
		if velocity == 0:
			velocity = max_velocity
		position.x = position.x - velocity * delta
	check_if_survived()

func attacked():
	life = clampi(life - 1, 0, max_life)
	velocity = clampf(velocity * 0.7, 50, max_velocity)
	position.x = position.x + 10
	$AnimationPlayer.play("attacked")
	if life == 0:
		queue_free()
		killed.emit(self)

func stop():
	current_state = STATES.STOP
	
func move():
	current_state = STATES.MOVE

func check_if_survived():
	if position.x < 0:
		survived.emit(self)
		queue_free()

func secret_power(power: SecretPowerChecker.SECRET_POWERS):
	match power:
		SecretPowerChecker.SECRET_POWERS.MULTI_PUNCH:
			attacked()
		SecretPowerChecker.SECRET_POWERS.KAMEAMEA:
			attacked()
		SecretPowerChecker.SECRET_POWERS.MEGA_PUNCH:
			megapunched.emit(self)

func set_foe_values(new_type: String, new_max_life: int, new_max_velocity: int, sprite_frames: SpriteFrames):
	type = new_type
	max_life = new_max_life
	max_velocity = new_max_velocity
	$AnimatedSprite2D.sprite_frames = sprite_frames
