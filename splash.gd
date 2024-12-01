extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://main.tscn")
