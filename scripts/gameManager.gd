extends Node3D

# TODO: Need to create a scene (I think) for a 2D order, so we can put inside its config global variables
# This way, Control can duplicate the orders, and the gameManager can keep track of remaining time of each one
# TODO: Change stands into classes so its easier to know if it is aviable and which ingredient can go inside
var recipes_to_do: Array = []
var totalPoints = 0
var multiplier = 1
var time = Config.MAX_TIME

signal recipe_list_changed(new_list)

func add_value_in_list(value: int):
	# Yes for now I will only do int because y not
	recipes_to_do.append(value)
	emit_signal("recipe_list_changed", recipes_to_do)

func _ready() -> void:
	# Getting botty the bot ready
	var bot = $agent
	bot.SPEED = Config.BOT_SPEED # Overrides the speed value set in player.gd
	bot.CARRY_SPEED = Config.BOT_SPEED_ON_CARRY

func orderComplete(firstOrder: bool):
	# ATTENTION: When the order classes are created, we need to have the command completed as secondary parameter
	if firstOrder:
		if multiplier != Config.MAX_SCORE_MULTIPLIER:
			multiplier += Config.SCORE_MULTIPLIER_FACTOR
		totalPoints += Config.SCORE_PER_ORDER * multiplier
	else:
		multiplier = 1
		totalPoints += Config.SCORE_PER_ORDER
