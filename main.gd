extends Node2D

@export var foe_scene: PackedScene

var points: int = 0
@export var life: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.set_life(life)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_foe_spawn_timer_timeout() -> void:
	_spawn_new_enemy()

func _spawn_new_enemy() -> void:
	var new_enemy = foe_scene.instantiate()
	add_child(new_enemy)
	new_enemy.killed.connect(_on_enemy_killed)
	new_enemy.survived.connect(_on_enemy_survived)

func _on_enemy_killed() -> void:
	points = points + 1
	$UI.set_points(points)

func _on_enemy_survived() -> void:
	life = life -1
	$UI.set_life(life)
	_check_if_dead()
	
func _check_if_dead():
	if life < 1:
		$UI.show_dead()
		$FoeSpawnTimer.stop()
