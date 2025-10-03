extends Interactible

class_name IntGenerator
const ingredient = preload("res://scenes/ingredient.tscn")

func _init():
	taskType = Enum.TaskType.GENERATE_ONION
	passive = true
	canBeOccupied = false
	
func store(_i:Movable) -> bool:
	return false
	
	
func unstore() -> Movable:
	var inst = ingredient.instantiate()
	add_child(inst)
	inst.set_global_position(position)
	return inst
