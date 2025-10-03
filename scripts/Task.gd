extends Object

class_name Task

var type:Enum.TaskType
var destination:Node3D
var object:Node3D
var occupied:bool
var previousTasks:Array[Task]
var nextTask:Task
var hierarchy:Hierarchy

func _init(h:Hierarchy, t:Enum.TaskType, o:Node3D, a:Array[Task] = []):
	hierarchy = h
	type = t
	object = o
	previousTasks = a
	if(o):
		o.occupied = true
	occupied = false
	for task in a:
		task.nextTask = self

func start(d:Node3D):
	destination = d
	occupied = true
	if d.canBeOccupied:
		d.occupied = true

func previousTaskComplete(t:Task, n:Node3D):
	object = n
	previousTasks.erase(t)

func complete(n:Node3D, agent:Agent):
	agent.task = null
	agent.order = Enum.Order.NONE
	if(nextTask):
		if type == Enum.TaskType.POT:
			nextTask.previousTaskComplete(self, destination)
		else:
			nextTask.previousTaskComplete(self, n)
		
	hierarchy.TaskList.erase(self)
	#if(destination): print("task complete : " + Enum.TaskType.keys()[type] + " to " + destination.name + " by " + agent.name)
	#else: print("task complete : " + Enum.TaskType.keys()[type] + " by " + agent.name)

func addPrevious(t:Task):
	previousTasks.append(t)
	t.nextTask = self
