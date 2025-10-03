extends Control

@onready var button = $Button
@onready var orderTemplate = $Order
@onready var orderContainer = $HBoxContainer

func _ready() -> void:
	var parent = get_parent()
	parent.connect("addedOrder", addOrder)
	orderTemplate.visible = false

func addOrder(order):
	var newOrder = orderTemplate.duplicate()
	newOrder.recipe = order
	newOrder.visible = true
	newOrder.priority = get_child_count()
	orderContainer.add_child(newOrder)
	newOrder.set_custom_minimum_size(Vector2(150, 30))
	newOrder.set_up()
