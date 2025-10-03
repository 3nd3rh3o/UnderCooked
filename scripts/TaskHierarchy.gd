extends Node3D
class_name Hierarchy

var AgentList:Array[Agent]
var TaskList:Array[Task]
var availableAgent:int

func findClosestAgent(n:Node3D) -> Agent:
	if(n):
		var bestDistance:float = INF
		var bestAgent:Agent = null
		for agent in get_tree().get_nodes_in_group("agent"):
			var distance:float = agent.storePoint.global_position.distance_to(n.global_position)
			if(agent.order == Enum.Order.NONE and distance < bestDistance):
				bestDistance = distance
				bestAgent = agent;
		return bestAgent
	return null

func find_free_movable(s:String) -> Node3D:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied):
			return obj
	return null
	
func find_free_interactible(s:String) -> Node3D:
	for obj in get_tree().get_nodes_in_group(s):
		if(not obj.occupied and not obj.storedObject):
			return obj
	return null

func find_free_oject_on_table(movable:String, taskType:Enum.TaskType) -> Node3D:
	for obj in get_tree().get_nodes_in_group(movable):
		if(obj.parent and obj.parent.taskType == taskType and not obj.occupied):
			return obj
	return null

func dropToNearestCounter(agent:Agent):
	var counter = find_free_interactible("IntSTORE")
	if(agent.task):
		agent.task.occupied = false
	print(str(agent) + "  1")
	setAgentTarget(agent, Task.new(self, Enum.TaskType.STORE, agent.objectInHand), counter, Enum.Order.STORE)

func setAgentTarget(agent:Agent, task:Task, destination:Node3D, order:Enum.Order = Enum.Order.NONE):
	if(agent and task and destination):
		agent.task = task
		if(task.object):
			task.object.occupied = true
		task.start(destination)
		agent.order = order
		print(Enum.TaskType.keys()[task.type])



func createSoup():
	var emptyPot = find_free_movable("PotEMPTY")
	if(emptyPot):
		var layer4:Task = Task.new(self, Enum.TaskType.SERVE, null)
		TaskList.append(layer4)
		var layer3:Task = Task.new(self, Enum.TaskType.COOK, null)
		layer4.addPrevious(layer3)
		TaskList.append(layer3)
		emptyPot.occupied = true
		for i in range(3):
			var layer2:Task = Task.new(self, Enum.TaskType.POT, null)
			layer2.destination = emptyPot
			TaskList.append(layer2)
			layer3.addPrevious(layer2)
			var layer1:Task = Task.new(self, Enum.TaskType.CUT, null)
			TaskList.append(layer1)
			layer2.addPrevious(layer1)
			var ing = find_free_movable("RAWONION")
			if(ing):
				ing.occupied = true
				layer1.object = ing
			else:
				var layer0:Task = Task.new(self, Enum.TaskType.GENERATE_ONION, null)
				TaskList.append(layer0)
				layer1.addPrevious(layer0)


func pickup(task:Task):
	var agent = findClosestAgent(task.object)
	setAgentTarget(agent, task, task.object, Enum.Order.PICKUP)
	
func generate(task:Task, type:Enum.IngType):
	var generator = find_free_interactible("IntGENERATE_"+Enum.IngType.keys()[type])
	var agent = findClosestAgent(generator)
	setAgentTarget(agent, task, generator, Enum.Order.UNSTORE)

func cut(task:Task):
	var cutter = find_free_interactible("IntCUT")
	var agent = findClosestAgent(task.object)
	setAgentTarget(agent, task, cutter, Enum.Order.USE)
	
func pot(task:Task):
	var agent = findClosestAgent(task.object)
	setAgentTarget(agent, task, task.destination, Enum.Order.STORE)

func cook(task:Task):
	var stove = find_free_interactible("IntCOOK")
	var agent = findClosestAgent(task.object)
	setAgentTarget(agent, task, stove, Enum.Order.STORE)

func empty(task:Task):
	if(task.object and task.object.state == Enum.IngState.COOKED):
		var servePoint = find_free_interactible("IntSERVE")
		var agent = findClosestAgent(task.object)
		setAgentTarget(agent, task, servePoint, Enum.Order.STORE)


func assignTasks(task:Task):
	if(task.previousTasks.size() == 0 and not task.occupied):
		match task.type:
			Enum.TaskType.PICKUP:
				pickup(task)
			Enum.TaskType.GENERATE_ONION:
				generate(task, Enum.IngType.ONION)
			Enum.TaskType.CUT:
				cut(task)
			Enum.TaskType.POT:
				pot(task)
			Enum.TaskType.COOK:
				cook(task)
			Enum.TaskType.SERVE:
				empty(task)
	else:
		for task2 in task.previousTasks:
			if(availableAgent <= 0):
				return
			assignTasks(task2)


func _process(_delta):
	createSoup()
	availableAgent = AgentList.size()
	for a in AgentList:
		if a.task :
			availableAgent -= 1
	print(TaskList.size())
	for task in TaskList:
		assignTasks(task)


func _enter_tree():
	add_to_group("Hierarchy")

	
