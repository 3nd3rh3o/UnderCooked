extends Node3D

var recipes_to_do: Array = []

signal recipe_list_changed(new_list)

func add_value_in_list(value: int):
	# Yes for now I will only do int because y not
	recipes_to_do.append(value)
	emit_signal("recipe_list_changed", recipes_to_do)

func _ready() -> void:
	# Getting botty the bot ready
	var bot = $agent
	bot.SPEED = Config.BOT_SPEED # Overrides the speed value set in player.gd
	#bot.CARRY_SPEED = Config.BOT_SPEED_ON_CARRY
