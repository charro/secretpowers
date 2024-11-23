extends HBoxContainer

@export var first_key: PackedScene
@export var second_key: PackedScene
@export var third_key: PackedScene
@export var fourth_key: PackedScene
@export var plus_sign: PackedScene

@onready var key_map = {
	SecretPower.ACTION_KEYS.FIRST: first_key,
	SecretPower.ACTION_KEYS.SECOND: second_key,
	SecretPower.ACTION_KEYS.THIRD: third_key,
	SecretPower.ACTION_KEYS.FOURTH: fourth_key
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clean():
	var children = get_children()
	for child in children:
		child.queue_free()

func add_key(key: SecretPower.ACTION_KEYS):
	var key_scene = key_map[key]
	var new_key = key_scene.instantiate()
	add_child(new_key)
