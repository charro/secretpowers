extends Node2D

@export var foe_scene: PackedScene
@export var life: int
var points: int = 0
var level: int = 0
var points_to_reach_next_level: Array[Variant] = [1, 20, 50, 100, 200, 300]

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
	new_enemy.position = $FoesSpawningPoint.position
	add_child(new_enemy)
	new_enemy.add_to_group("foes")
	new_enemy.add_to_group("moving")
	new_enemy.killed.connect(_on_enemy_killed)
	new_enemy.survived.connect(_on_enemy_survived)

func _on_enemy_killed() -> void:
	points = points + 1
	$UI.set_points(points)
	_check_if_next_level()

func _on_enemy_survived() -> void:
	life = life -1
	$UI.set_life(life)
	_check_if_dead()
	
func _check_if_dead():
	if life < 1:
		$UI.show_dead()
		$FoeSpawnTimer.stop()

func _check_if_next_level():
	if points >= points_to_reach_next_level[level]:
		print("LEVEL UP!!")
		var points_needed_for_next_level = \
				points_to_reach_next_level[level + 1] - points_to_reach_next_level[level]
		var keys_on_new_power = $SecretPowerChecker.get_keys_on_secret_power(level)
		level += 1
		$UI.level_up(level, points_needed_for_next_level, keys_on_new_power)
		_stop_foes()
		$NextLevelTimer.start()

func _stop_foes():
	get_tree().call_group("moving", "stop")
	$FoeSpawnTimer.stop()

func _start_next_level():
	_move_foes()
	$UI.hide_pop_ups()
	$SecretPowerChecker.new_power_unblocked()

func _move_foes():
	get_tree().call_group("moving", "move")
	$FoeSpawnTimer.start()
