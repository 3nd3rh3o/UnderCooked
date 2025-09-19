extends Node3D

func dupe(objectName: String, coordinates: Vector3):
	var object = self.find_child(objectName)
	var copy: Node3D = object.duplicate()
	self.add_child(copy)
	copy.position = coordinates;
	copy.visible = true


func _ready():
	dupe("tomatoGenerator", Vector3(6, 0, 2))
