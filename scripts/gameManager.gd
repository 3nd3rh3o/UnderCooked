extends Node3D

class_name GameManager
# TODO: Change stands into classes so its easier to know if it is aviable and which ingredient can go inside
# TODO: multiple recipes/ingredients can be picked up at once when the player holds a plate. Create that plate
var active_orders: Array[Recipe] = []
var recipes_aviable: Array[Recipe] = []
var totalPoints = 0
var multiplier = 1
var time = Config.MAX_TIME
var order_interval_time = 0
var agents: Array
var hierarchy:Hierarchy
@onready var GUIController = $Control

signal addedOrder(order)
signal removedOrder(order)

func get_composite_recipes() -> Array[Recipe]:
	return recipes_aviable.filter(func(r):
			return r.available_for_order;
	)

func add_random_order(amount: int):
	for i in range(amount):
		var possible_orders = get_composite_recipes()
		if possible_orders.is_empty():
			return
		var order = possible_orders.pick_random()
		if(order.item.name == "Tomato Soup"):
			if(hierarchy.createSoup()):
				active_orders.append(order)
				print("addedOrder")
				emit_signal("addedOrder", order)
				return true
		if(order.item.name == "Hamburger"):
			if(hierarchy.createBurger()):
				active_orders.append(order)
				emit_signal("addedOrder", order)
				return true
	return false
	

func order_expired(recipe: Recipe):
	totalPoints -= Config.SCORE_PENALTY_EXPIRE_ORDER
	active_orders.erase(recipe.item.name)
	multiplier = 1
	print("Order expired! total points: ", str(totalPoints), ", multiplier: ", str(multiplier))

func _init():
	add_to_group("gameManager")

func _ready() -> void:
	var bot = $agent
	hierarchy = get_tree().get_nodes_in_group("Hierarchy")[0]
	recipes_aviable = load_all_recipes("res://data/recipes/")
	bot.SPEED = Config.BOT_SPEED # Overrides the speed value set in player.gd
	GUIController.connect("expired_order", order_expired)
	agents = getAgents()

func tryOrderComplete(s:String):
	for o in active_orders:
		if o.item.name == s:
			orderComplete(true, o)
			return

func orderComplete(firstOrder: bool, O: Recipe):
	# ATTENTION: When the order classes are created, we need to have the command completed as secondary parameter
	totalPoints += Config.SCORE_PER_ORDER * multiplier
	if firstOrder and multiplier != Config.MAX_SCORE_MULTIPLIER:
			multiplier = multiplier + Config.SCORE_MULTIPLIER_FACTOR - 1
	active_orders.erase(O)
	emit_signal("removedOrder", O)

func load_all_recipes(path: String) -> Array[Recipe]:
	var dir = DirAccess.open(path)
	var recipes: Array[Recipe] = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var recipe = load(path + "/" + file_name)
				if recipe is Recipe:
					recipes.append(recipe)
			file_name = dir.get_next()
	return recipes

func getAgents():
	agents = []
	for child in get_children():
		if child.get_scene_file_path() == "res://scenes/agent.tscn":
			agents.append(child)
	return agents

func _process(delta: float) -> void:
	# orders
	if (len(active_orders) < Config.MAX_ORDER):
		order_interval_time = min(Config.ORDER_INTERVAL, order_interval_time + delta)
		if (order_interval_time == Config.ORDER_INTERVAL):
			if(add_random_order(1)):
				order_interval_time = 0
			
	# agents
	for agent in agents:
		agent.executeTask()
