extends Area2D

@export var max_velocity: float = 200
var velocity: float

func _ready() -> void:
	velocity = max_velocity
	
func _process(delta: float) -> void:
	position.x = position.x + velocity * delta

func _on_area_entered(foe: Foe) -> void:
	foe.secret_power(SecretPowerChecker.SECRET_POWERS.KAMEAMEA)
