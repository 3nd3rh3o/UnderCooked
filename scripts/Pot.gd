extends Movable
class_name Pot
@export var mesh:MeshInstance3D

var progress = {Enum.TaskType.COOK:1}
var state:Enum.IngState = Enum.IngState.RAW;
	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(recipe == Enum.RecipeNames.PotCutTomCutTomCutTom):
		if(progress.has(s)):
			progress[s] -= delta
			if(progress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					cook()
				return true
	return false

func store(i:Ingredient):
	i.parent.objectInHand = null
	if(recipe == Enum.RecipeNames.Empty):
		recipe = Recipes.recipesPot(i.recipe)
	else:
		recipe = Recipes.recipesMix(recipe, i.recipe)
		if(recipe == Enum.RecipeNames.PotCutTomCutTomCutTom):
			remove_from_group("PotEMPTY")
	i.queue_free()
	UpdateAppearance()


func _enter_tree():
	super._enter_tree()
	add_to_group("PotEMPTY")

func empty():
	occupied = false
	state = Enum.IngState.RAW
	progress = {Enum.TaskType.COOK:1}
	add_to_group("PotEMPTY")
	recipe = Enum.RecipeNames.Empty
	UpdateAppearance()
		
	
func cook():
	state = Enum.IngState.COOKED
	recipe = Recipes.recipesCook(recipe)
	UpdateAppearance()

func _process(_delta):
	super._process(_delta)
