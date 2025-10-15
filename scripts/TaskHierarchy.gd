extends Node3D
class_name Hierarchy

var TaskList:Array[Task]
var availableAgent:int
@export var agent:Agent



func find_closest_interactible(n:Node3D, s:String) -> Interactible:
	var bestDistance:float = INF
	var bestObj:Interactible = null
	for obj in get_tree().get_nodes_in_group(s):
		var distance:float = obj.global_position.distance_to(n.global_position)
		if(not obj.occupied and not obj.storedObject and distance < bestDistance):
			bestDistance = distance
			bestObj = obj;
	return bestObj

func find_free_movable(s:String) -> Movable:
	var backup = null
	for obj in get_tree().get_nodes_in_group(s):
		if(obj is MovableCooker):
			if(obj.parent is IntStove):
				return obj
			else:
				backup = obj
		elif(not obj.occupied):
			return obj
	return backup

func find_free_interactible(s:String) -> Interactible:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied and not obj.storedObject):
			return obj
	return null

func find_free_oject_on_table(movable:String, taskType:Enum.TaskType) -> Node3D:
	for obj in get_tree().get_nodes_in_group(movable):
		if(obj.parent and obj.parent.taskType == taskType and not obj.occupied):
			return obj
	return null

func dropToNearestCounter():
	if(agent.objectInHand is MovableCooker): #permet de reposer les pan ou pot sur les stove
		var nearestCooker = find_closest_interactible(agent, "IntCOOK")
		if(nearestCooker):
			if(agent.task):
				agent.task.abandon()
			setAgentTarget(Task.new(self, Enum.TaskType.STORE, agent.objectInHand), nearestCooker, Enum.Order.STORE)
			return
	
	var nearestCounter = find_closest_interactible(agent, "IntSTORE")
	if(nearestCounter):
		if(agent.task):
			agent.task.abandon()
		setAgentTarget(Task.new(self, Enum.TaskType.STORE, agent.objectInHand), nearestCounter, Enum.Order.STORE)
	else:
		agent.dropObject()


func setAgentTarget(task:Task, destination:Node3D, order:Enum.Order = Enum.Order.NONE):
	if(agent and task and destination):
		task.start(destination, agent)
		agent.order = order



func createSoup():
	var emptyPot = find_free_movable("PotEMPTY")
	if(emptyPot):
		var soupServe:Task = Task.new(self, Enum.TaskType.EMPTY, emptyPot)
		TaskList.append(soupServe)
		var soupCook:Task = Task.new(self, Enum.TaskType.COOK, emptyPot)
		soupServe.addPrevious(soupCook)
		TaskList.append(soupCook)
		for i in range(3):
			var tomPot:Task = Task.new(self, Enum.TaskType.POT, null)
			tomPot.destination = emptyPot
			TaskList.append(tomPot)
			soupCook.addPrevious(tomPot)
			var tomCut:Task = Task.new(self, Enum.TaskType.CUT, null)
			TaskList.append(tomCut)
			tomPot.addPrevious(tomCut)
			var ing = find_free_movable("Tom")
			if(ing):
				tomCut.object = ing
			else:
				var tomGen:Task = Task.new(self, Enum.TaskType.GENERATE_TOMATO, null)
				TaskList.append(tomGen)
				tomCut.addPrevious(tomGen)
		return true
	return false

func createBurger():
	var emptyPan = find_free_movable("PanEMPTY")
	if(emptyPan):
		var burgServe:Task = Task.new(self, Enum.TaskType.EMPTY, null)
		TaskList.append(burgServe)
		
		var salMix:Task = Task.new(self, Enum.TaskType.MIX, null)
		TaskList.append(salMix)
		burgServe.addPrevious(salMix)
		var steEmpty:Task = Task.new(self, Enum.TaskType.EMPTY, null)
		TaskList.append(steEmpty)
		burgServe.addPrevious(steEmpty)
		
		var steCook:Task = Task.new(self, Enum.TaskType.COOK, emptyPan)
		TaskList.append(steCook)
		steEmpty.addPrevious(steCook)
		
		var stePan:Task = Task.new(self, Enum.TaskType.POT, null)
		TaskList.append(stePan)
		stePan.destination = emptyPan
		steCook.addPrevious(stePan)
		
		var salCut:Task = Task.new(self, Enum.TaskType.CUT, null)
		TaskList.append(salCut)
		salMix.addPrevious(salCut)
		var steCut:Task = Task.new(self, Enum.TaskType.CUT, null)
		TaskList.append(steCut)
		stePan.addPrevious(steCut)
		
		var burGen:Task = Task.new(self, Enum.TaskType.GENERATE_BURGER, null)
		TaskList.append(burGen)
		burGen.giveDestinationTo = [salMix, steEmpty]
		
		var steGen = Task.new(self, Enum.TaskType.GENERATE_STEAK, null)
		TaskList.append(steGen)
		steCut.addPrevious(steGen)
		var salGen = Task.new(self, Enum.TaskType.GENERATE_SALAD, null)
		TaskList.append(salGen)
		salCut.addPrevious(salGen)
		return true
	return false

func pickup(task:Task):
	if(agent.task == null):
		setAgentTarget(task, task.object, Enum.Order.PICKUP)
	
func generate(task:Task, ingName:Enum.RecipeNames):
	var generator = find_free_interactible("Generator"+Enum.RecipeNames.keys()[ingName])
	if(agent.task == null):
		setAgentTarget(task, generator, Enum.Order.UNSTORE)

func cut(task:Task):
	var cutter = find_free_interactible("IntCUT")
	if(agent.task == null and cutter):
		setAgentTarget(task, cutter, Enum.Order.USE)
	
func pot(task:Task):
	if(agent.task == null):
		setAgentTarget(task, task.destination, Enum.Order.STORE)	
		
func mix(task:Task):
	if(agent.task == null):
		setAgentTarget(task, task.destination, Enum.Order.MIX)

func cook(task:Task):
	var stove
	if(task.object.parent and task.object.parent is IntStove):
		stove = task.object.parent
	else:
		stove = find_free_interactible("IntCOOK")
	if(agent.task == null and stove):
		setAgentTarget(task, stove, Enum.Order.STORE)

func empty(task:Task):
	if(task.object is Ingredient):
		var servePoint = find_free_interactible("IntEMPTY")
		if(agent.task == null and servePoint):
			setAgentTarget(task, servePoint, Enum.Order.STORE)
	elif(task.object and task.object.canEmpty()):
		if(task.destination == null or task.destination is IntServe):
			var servePoint = find_free_interactible("IntEMPTY")
			if(agent.task == null and servePoint):
				setAgentTarget(task, servePoint, Enum.Order.STORE)
		else:
			if(agent.task == null):
				setAgentTarget(task, task.destination, Enum.Order.MIX)


func assignTasks(task:Task):
	#print(str(task) + " " + str(task.previousTasks.size())+ " " + str(task.occupied) + " " +str(task.assignedAgent))
	if(task.previousTasks.size() == 0 and task.available()):
		match task.type:
			Enum.TaskType.PICKUP:
				pickup(task)
			Enum.TaskType.GENERATE_TOMATO:
				generate(task, Enum.RecipeNames.Tom)
			Enum.TaskType.GENERATE_BURGER:
				generate(task, Enum.RecipeNames.Bur)
			Enum.TaskType.GENERATE_STEAK:
				generate(task, Enum.RecipeNames.Ste)
			Enum.TaskType.GENERATE_SALAD:
				generate(task, Enum.RecipeNames.Sal)
			Enum.TaskType.CUT:
				cut(task)
			Enum.TaskType.POT:
				pot(task)
			Enum.TaskType.COOK:
				cook(task)
			Enum.TaskType.MIX:
				mix(task)
			Enum.TaskType.EMPTY:
				empty(task)


func _process(_delta):
	for task in TaskList:
		assignTasks(task)


func _enter_tree():
	add_to_group("Hierarchy")

	
