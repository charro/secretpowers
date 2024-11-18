extends Node2D

@export var foe_scene: PackedScene
@export var life: int
var points: int = 0
var level = 0
var points_to_reach_next_level = [10, 20, 35, 55, 80, 120]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.set_life(life)
	for actionName in InputMap.get_actions():
		print("%s:" % actionName)
		for action_event in InputMap.action_get_events(actionName):
			print("  %s" % action_event.as_text())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_foe_spawn_timer_timeout() -> void:
	_spawn_new_enemy()

func _spawn_new_enemy() -> void:
	var new_enemy = foe_scene.instantiate()
	new_enemy.position = $FoesSpawningPoint.position
	add_child(new_enemy)
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
		$UI.level_up(points_needed_for_next_level)
		level += 1
