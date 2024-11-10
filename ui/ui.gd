extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_points(points: int):
	$Points.text = str(points)
	
func set_life(life: int):
	$Life.text = str(life)

func show_dead():
	$GameOver.visible = true
