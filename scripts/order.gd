extends Control

@export var recipe: Recipe
@export var time = Config.ORDER_EXPIRE_TIME
@export var priority = 1
@onready var label = $Panel/Label
@onready var panel = $Panel

func set_up():
	label.text = recipe.name
	label.size = Vector2(150, 30)
	size = Vector2(150, 30)
	panel.size = Vector2(150, 30)
