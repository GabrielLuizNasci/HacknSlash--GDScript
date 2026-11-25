class_name MoveState extends State

func physics_update(_delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if input.length() == 0:
		state_finished.emit("IdleState")
		return
	character.handle_movement(input, _delta)
