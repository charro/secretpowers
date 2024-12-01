extends Node2D

@export var foe_scene: PackedScene
@export var kameamea_scene: PackedScene
@export var life: int
var accumulated_points: int = 0
var points_in_this_level = 0
var level: int = 0
var points_to_reach_next_level: Array[Variant] = [5, 20, 40, 80]

var foe_sprites = preload("res://foe/sprite_frames/foe.tres")
var elplumas_sprites = preload("res://foe/sprite_frames/elplumas.tres")
var tortugato_sprites = preload("res://foe/sprite_frames/tortugato.tres")
var cabezon_sprites = preload("res://foe/sprite_frames/cabezon.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.set_life(life)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_foe_spawn_timer_timeout() -> void:
	_spawn_new_enemy()

func _spawn_new_enemy() -> void:
	var new_enemy = _create_foe_for_current_level()
	new_enemy.position = $FoesSpawningPoint.position
	add_child(new_enemy)
	new_enemy.add_to_group("foes")
	new_enemy.add_to_group("moving")
	new_enemy.killed.connect(_on_enemy_killed)
	new_enemy.survived.connect(_on_enemy_survived)
	new_enemy.megapunched.connect(_on_foe_megapunched)

func _on_enemy_killed(foe: Foe) -> void:
	points_in_this_level = points_in_this_level + foe.max_life
	$UI.set_points(points_in_this_level)
	_check_if_next_level()

func _on_enemy_survived(foe: Foe) -> void:
	life = life - foe.max_life
	$UI.set_life(life)
	_check_if_dead()
	
func _check_if_dead():
	if life < 1:
		$UI.game_over()
		stop_the_world()
		$FoeSpawnTimer.stop()

func _check_if_next_level():
	# Level UP
	if accumulated_points + points_in_this_level >= points_to_reach_next_level[level]:
		_level_up()

func _level_up():
	# We're in max level, YOU WIN
	if level == points_to_reach_next_level.size() - 1:
		stop_the_world()
		$UI.game_won()
	else: 
		accumulated_points += points_in_this_level
		points_in_this_level = 0
		var points_needed_for_next_level = \
				points_to_reach_next_level[level + 1] - points_to_reach_next_level[level]
		var keys_on_new_power = $SecretPowerChecker.get_keys_on_secret_power(level)
		
		level += 1
		$FoeSpawnTimer.max_wait_time = 3 * level
		$Player.level = level
		$UI.level_up(level, points_needed_for_next_level, keys_on_new_power)
		$SecretPowerChecker.new_power_unblocked()
		stop_the_world()
		$StopTheWorldTimer.start()

func stop_the_world():
	_stop_foes()
	_stop_player()

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
	$StopTheWorldTimer.start()

func _on_foe_megapunched(foe: Foe):
	var tween = create_tween()
	tween.tween_property(foe, "position", $MegapunchTopPoint.position, 0.5)
	tween.tween_property(foe, "position", $FoesSpawningPoint.position, 0.2)

func _create_foe_for_current_level() -> Foe :
	var foe: Foe = _spawn_cabezon()
	match level:
		1:
			if randf_range(0, 1) > 0.6:
				foe = _spawn_elplumas()
		2:
			var chances = randf_range(0, 1)
			if chances > 0.7:
				foe = _spawn_tortugato()
			elif chances > 0.3:
				foe = _spawn_elplumas()
		3:
			var chances = randf_range(0, 1)
			if chances > 0.5:
				foe = _spawn_cabezon()
			elif chances > 0.2:
				foe = _spawn_tortugato()
			else:
				foe = _spawn_elplumas()
	return foe

func _spawn_elplumas():
	var foe: Foe = foe_scene.instantiate()
	foe.set_foe_values(15, 250, elplumas_sprites)
	return foe
	
func _spawn_tortugato():
	var foe: Foe = foe_scene.instantiate()
	foe.set_foe_values(40, 150, tortugato_sprites)
	return foe

func _spawn_cabezon():
	var foe: Foe = foe_scene.instantiate()
	foe.set_foe_values(100, 80, cabezon_sprites)
	foe.position.y = foe.position.y + 40
	return foe
