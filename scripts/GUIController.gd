extends Control

@onready var label = $Label
@onready var button = $Button
@onready var orderTemplate = $Order


func _ready() -> void:
	orderTemplate.visible = false
	addOrder("Cheeze")

func addOrder(recipe):
	var newOrder = orderTemplate.duplicate()
	newOrder.recipe = recipe
	newOrder.visible = true
	newOrder.priority = get_child_count()
	add_child(newOrder)
	print(newOrder.priority)
