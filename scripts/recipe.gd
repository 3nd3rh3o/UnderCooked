# I think this is how a recipe should work

extends Resource

class_name Recipe

@export var item: Item
@export var recipeNeeded: Array[Item]
@export var standNeeded: Stand
@export var available_for_order: bool
