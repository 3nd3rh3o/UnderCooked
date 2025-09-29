extends Control

@export var recipe: Recipe
@export var time = Config.ORDER_EXPIRE_TIME
@export var priority = 1
@onready var label = $Label

func set_up():
	label.text = recipe.name
