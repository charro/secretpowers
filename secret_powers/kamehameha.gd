extends Area2D

@export var max_velocity: float = 200
var velocity: float

func _ready() -> void:
	velocity = max_velocity
	
func _process(delta: float) -> void:
	position.x = position.x + velocity * delta
	if position.x > get_viewport_rect().size.x:
		queue_free()

func _on_area_entered(enemy: Area2D) -> void:
	enemy.add_to_group("touching_player")

func _on_area_exited(enemy: Area2D) -> void:
	enemy.remove_from_group("touching_player")

func _on_animated_sprite_2d_frame_changed() -> void:
	get_tree().call_group("touching_player", "secret_power", SecretPowerChecker.SECRET_POWERS.KAMEAMEA)
