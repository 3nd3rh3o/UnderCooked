extends Control

@export var recipe = "cut tomato" # ATTENTION: When recipe class is created, it will be of this class
@export var time = Config.ORDER_EXPIRE_TIME
@export var priority = 1
@onready var label = $Label

func _ready():
	label.text = recipe
