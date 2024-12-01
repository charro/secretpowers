extends Panel
class_name KeysCombinationPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_keys_combination(keys):
	$Keys/KeysContainer.clean()
	for key in keys:
		$Keys/KeysContainer.add_key(key)

func set_custom_label_text(new_text):
	$CustomLabel.text = new_text
