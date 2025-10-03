extends Movable
class_name Ingredient
@export var mesh:MeshInstance3D

var state:Enum.IngState = Enum.IngState.RAW
var type:Enum.IngType = Enum.IngType.ONION
var progress = {Enum.TaskType.CUT:0.5}

func changeState(s:Enum.IngState):
	remove_from_group(Enum.IngToString(state, type))
	state = s
	add_to_group(Enum.IngToString(state, type))
	
func addProgress(s:Enum.TaskType, delta:float) -> bool:
	if(progress.has(s)):
		progress[s] -= delta
		if(progress[s] <= 0):
			if(s == Enum.TaskType.CUT):
				cut()
			return true
	return false

func _enter_tree():
	super._enter_tree()
	add_to_group(Enum.IngToString(state, type))

func cut():
	pass
	changeState(Enum.IngState.CUT)
	var mat := mesh.get_active_material(0)

	if mat and mat.resource_name == "":
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = Color.RED

func cook():
	changeState(Enum.IngState.COOKED)
	var mat := mesh.get_active_material(0)

	if mat and mat.resource_name == "":
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = Color.BLACK

func _process(_delta):
	super._process(_delta)
