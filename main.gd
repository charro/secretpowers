extends Node2D

@export var foe_scene: PackedScene
@export var kameamea_scene: PackedScene
@export var life: int
var accumulated_points: int = 0
var points_in_this_level = 0
var level: int = 0
var points_to_reach_next_level: Array[Variant] = [1, 5, 10, 100, 200, 300]

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
	new_enemy.megapunched.connect(_on_foe_megapunched)

func _on_enemy_killed() -> void:
	points_in_this_level = points_in_this_level + 1
	$UI.set_points(points_in_this_level)
	_check_if_next_level()

func _on_enemy_survived() -> void:
	life = life - 1
	$UI.set_life(life)
	_check_if_dead()
	
func _check_if_dead():
	if life < 1:
		$UI.show_dead()
		$FoeSpawnTimer.stop()

func _check_if_next_level():
	if accumulated_points + points_in_this_level >= points_to_reach_next_level[level]:
		accumulated_points += points_in_this_level
		points_in_this_level = 0
		var points_needed_for_next_level = \
				points_to_reach_next_level[level + 1] - points_to_reach_next_level[level]
		var keys_on_new_power = $SecretPowerChecker.get_keys_on_secret_power(level)
		level += 1
		$Player.level = level
		$UI.level_up(level, points_needed_for_next_level, keys_on_new_power)
		$SecretPowerChecker.new_power_unblocked()
		stop_the_world()

func stop_the_world():
	_stop_foes()
	_stop_player()
	$StopTheWorldTimer.start()

func _stop_foes():
	get_tree().call_group("moving", "stop")
	$FoeSpawnTimer.stop()

func _stop_player():
	$Player.stop()

func start_the_world():
	_move_foes()
	$Player.move()
	$UI.hide_pop_ups()

func _move_foes():
	get_tree().call_group("moving", "move")
	$FoeSpawnTimer.start()

func _on_secret_power_checker_secret_power_triggered(secret_power: SecretPowerChecker.SECRET_POWERS) -> void:
	match secret_power:
		SecretPowerChecker.SECRET_POWERS.KAMEAMEA:
			var kameamea = kameamea_scene.instantiate()
			kameamea.position = $PowerSpawningPoint.position
			add_child(kameamea)

func _on_stop_the_world_timer_timeout() -> void:
	start_the_world()

func _on_secret_power_checker_new_secret_power_found() -> void:
	stop_the_world()

func _on_foe_megapunched(foe: Foe):
	var tween = create_tween()
	tween.tween_property(foe, "position", $MegapunchTopPoint.position, 0.5)
	tween.tween_property(foe, "position", $FoesSpawningPoint.position, 0.2)
