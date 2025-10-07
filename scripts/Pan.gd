extends MovableCooker
class_name Pan
@export var mesh:MeshInstance3D

	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.CutSte):
		if(currentProgress.has(s)):
			currentProgress[s] -= delta
			if(currentProgress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					cook()
				return true
	return false

func canEmpty()->bool:
	return recipe == Enum.RecipeNames.CookCutSte

func store(i:Ingredient):
	i.parent.objectInHand = null
	if(recipe == Enum.RecipeNames.Empty):
		recipe = i.recipe
		remove_from_group(groupName)
		i.queue_free()
		UpdateAppearance()


func _enter_tree():
	groupName = "PanEMPTY"
	progressMaxValues = {Enum.TaskType.COOK:1}
	super._enter_tree()
