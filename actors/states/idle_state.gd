class_name IdleState extends State

@export var friction: float = 12.0
@export var floor_snap_length: float = 0.1

func _ready() -> void:
	animation_name = "Idle"
	can_move = true

func enter() -> void:
	super.enter()

func physics_update(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity.y += character.get_character_gravity().y * delta
	else:
		character.velocity.y = -floor_snap_length
	
	character.velocity.x = lerp(character.velocity.x, 0.0, friction * delta)
	character.velocity.z = lerp(character.velocity.z, 0.0, friction * delta)
	
	character.move_and_slide()
