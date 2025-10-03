extends Interactible

func _init():
	taskType = Enum.TaskType.SERVE
	canBeOccupied = false
	passive = true

func store(i:Movable) -> bool:
	i.empty()
	return true
