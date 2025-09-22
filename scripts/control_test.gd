extends Control

@onready var label = $Label
@onready var button = $Button
@onready var node3D = get_parent()

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	node3D.recipe_list_changed.connect(_on_list_changed)

func _on_button_pressed():
	var new_recipe = randi() % 100
	node3D.add_value_in_list(new_recipe)
	
func _on_list_changed(new_list):
	label.text = str(new_list)
