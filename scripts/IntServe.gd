extends Interactible
class_name IntServe

var gameManager:GameManager
func _init():
	taskType = Enum.TaskType.EMPTY
	canBeOccupied = false
	passive = true


func _ready() -> void:
	gameManager = get_tree().get_nodes_in_group("gameManager")[0]

func store(i:Movable) -> bool:
	if(i is MovableCooker):
		if(i.recipe == Enum.RecipeNames.TomatoSoup):
			gameManager.tryOrderComplete("Tomato Soup")
		i.empty()
		return true
	elif(i is Ingredient):
		if(i.recipe == Enum.RecipeNames.Burger):
			gameManager.tryOrderComplete("Hamburger")
		i.parent.objectInHand = null
		i.queue_free()
		return true
	return false
