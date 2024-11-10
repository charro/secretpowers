extends Area2D

@export var velocity: int = 200

signal killed
signal survived

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = position.x - velocity * delta
	check_if_survived()
	
func attacked():
	queue_free()
	killed.emit()

func check_if_survived():
	if position.x < 0:
		survived.emit()
		queue_free()
