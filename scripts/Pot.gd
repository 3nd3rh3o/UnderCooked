extends Movable
class_name Pot
@export var mesh:MeshInstance3D

var progress = {Enum.TaskType.COOK:2}
var IngredientList:Array[Enum.IngType]
var state:Enum.IngState = Enum.IngState.RAW;
	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(IngredientList.size() >= 3):
		if(progress.has(s)):
			progress[s] -= delta
			if(progress[s] <= 0):
				if(s == Enum.TaskType.COOK):
					cook()
				return true
	return false

func store(i:Ingredient):
	i.parent.objectInHand = null
	IngredientList.append(i.type)
	i.queue_free()
	if(IngredientList.size() == 3):
		remove_from_group("PotEMPTY")
		add_to_group("PotFULL")
		var mat := mesh.get_active_material(0)
		if mat and mat.resource_name == "":
			mat = mat.duplicate()
			mesh.set_surface_override_material(0, mat)

		if mat is StandardMaterial3D:
			mat.albedo_color = Color.RED

func _enter_tree():
	super._enter_tree()
	add_to_group("POT")
	add_to_group("PotEMPTY")

func empty():
	occupied = false
	state = Enum.IngState.RAW
	progress = {Enum.TaskType.COOK:2}
	remove_from_group("PotFULL")
	remove_from_group("PotCOOKED")
	add_to_group("PotEMPTY")
	IngredientList = []
	var mat := mesh.get_active_material(0)
	if mat and mat.resource_name == "":
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = Color.WHITE

func cook():
	state = Enum.IngState.COOKED
	var mat := mesh.get_active_material(0)

	remove_from_group("PotEMPTY")
	add_to_group("PotCOOKED")
	if mat and mat.resource_name == "":
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = Color.BLACK

func _process(_delta):
	super._process(_delta)
