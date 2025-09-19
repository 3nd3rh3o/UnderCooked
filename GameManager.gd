extends Node3D

func dupe(objectName, coordinates):
	var object = self.find_child(objectName)
	var copy = object.duplicate()
	
func _ready():
	dupe("BakingPan", 0)
