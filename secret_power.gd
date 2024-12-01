extends Node2D
class_name SecretPower

enum ACTION_KEYS { FIRST, SECOND, THIRD, FOURTH }

@export var secret_power_id: SecretPowerChecker.SECRET_POWERS
@export var keys_combination: Array[ACTION_KEYS]


func matches(keys) -> bool:
	return keys == keys_combination
