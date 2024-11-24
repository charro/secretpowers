extends Node2D
class_name SecretPower

enum ACTION_KEYS { FIRST, SECOND, THIRD, FOURTH }

@export var secret_power_id: SecretPowerChecker.SECRET_POWERS
@export var keys_combination: Array[ACTION_KEYS]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func matches(keys) -> bool:
	return keys == keys_combination
