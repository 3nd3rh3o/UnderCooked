extends Control

@onready var label = $Label
@onready var button = $Button
@onready var orderTemplate = $Order

func _ready() -> void:
	var parent = get_parent()
	parent.connect("addedOrder", addOrder)
	orderTemplate.visible = false

func addOrder(order):
	var newOrder = orderTemplate.duplicate()
	newOrder.recipe = order
	newOrder.visible = true
	newOrder.priority = get_child_count()
	add_child(newOrder)
	newOrder.set_up()
