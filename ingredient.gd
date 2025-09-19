extends RigidBody3D
class_name Ingredient
@export var mesh:MeshInstance3D

var parent:Node3D;


func pickedUp(p:Node3D):
	parent = p
	
func dropped():
	parent = null
	
func _ready():
	add_to_group("rawIngredients")
	
func change_mesh_color():
	remove_from_group("rawIngredients")
	var mat := mesh.get_active_material(0)

	if mat and mat.resource_name == "":
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = Color.RED

func _process(delta):
	if parent:
		global_position = Vector3(parent.global_position)
		global_rotation = Vector3(parent.global_rotation)
