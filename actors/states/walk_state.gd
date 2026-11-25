class_name WalkState extends State

@export var walk_speed: float = 4.0
@export var accel_time: float = 0.2
@export var rotation_speed: float = 10.0

func _ready() -> void:
	animation_name = "Walk"
	can_move = true

func enter() -> void:
	super.enter()

func physics_update(delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var camera: Camera3D = character.get_viewport().get_camera_3d()
	var forward: Vector3
	var right: Vector3
	
	if camera:
		forward = -camera.global_transform.basis.z
		right = -camera.global_transform.basis.x
	else:
		forward = character.global_transform.basis.z
		right = character.global_transform.basis.x
	
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	var desired_direction: Vector3 = (forward * input_dir.y + right * input_dir.x).normalized()
	
	if desired_direction != Vector3.ZERO:
		var accel_rate := 1.0 / accel_time if accel_time > 0 else 10.0
		var target_velocity := desired_direction * walk_speed
		character.velocity.x = lerp(character.velocity.x, target_velocity.x, accel_rate * delta)
		character.velocity.z = lerp(character.velocity.z, target_velocity.z, accel_rate * delta)
		
		var current_dir := Vector3(character.velocity.x, 0, character.velocity.z).normalized()
		if current_dir != Vector3.ZERO:
			var alignment := current_dir.dot(desired_direction)
			var turn_slowdown := 0.5 + 0.5 * alignment
			character.velocity.x *= turn_slowdown
			character.velocity.z *= turn_slowdown
		
		var target_angle := atan2(desired_direction.x, desired_direction.z)
		var current_angle := character.rotation.y
		var angle_diff := fposmod(target_angle - current_angle + PI, TAU) - PI
		character.rotation.y += angle_diff * rotation_speed * delta
	else:
		var accel_rate := 1.0 / accel_time if accel_time > 0 else 10.0
		character.velocity.x = lerp(character.velocity.x, 0.0, accel_rate * delta)
		character.velocity.z = lerp(character.velocity.z, 0.0, accel_rate * delta)
	
	if not character.is_on_floor():
		character.velocity.y += character.get_character_gravity().y * delta
	character.move_and_slide()
	
	if input_dir.length() > 0:
		state_finished.emit("MoveState")
