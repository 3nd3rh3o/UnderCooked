extends CharacterBody3D

const SPEED = 5.0
const FLOOR_NORMAL = Vector3.UP
const JUMP_VELOCITY = 10.0

var gravity = -24.8
var direction = Vector3.ZERO
var lookdirection = Vector3.ZERO


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	direction = Vector3.ZERO;
	if input_dir != Vector2.ZERO:
		var forward = Vector3(0, 0, 1).normalized()   
		var right = Vector3(1, 0, 0).normalized()    
		direction = (right * input_dir.x + forward * input_dir.y).normalized()	 
		
		var target_angle = atan2(direction.x, direction.z)
		var current_angle = rotation.y
		var new_angle = lerp_angle(current_angle, target_angle, delta *10 )

		rotation.y = new_angle

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
