# I think this is how a recipe should work

extends Resource

class_name Recipe

@export var name: String
@export var recipeNeeded: Array[Recipe]
@export var standNeeded: Stand
