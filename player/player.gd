extends Area2D

var current_state = "idle"

var enemies_touching_player = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input()
	
func get_input():
	if Input.is_action_pressed("punch"):
		$AnimatedSprite2D.play("punch")
		current_state = "attack"
		for i in len(enemies_touching_player):
			var enemy = enemies_touching_player[i]
			enemy.queue_free()
			enemies_touching_player.remove_at(i)

func _on_animation_finished() -> void:
	$AnimatedSprite2D.animation = "idle"
	current_state = "idle"
 
func _on_player_area_entered(enemy: Area2D) -> void:
	enemies_touching_player.append(enemy)
	return
