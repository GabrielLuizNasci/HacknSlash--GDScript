extends CharacterBody3D

@export var gravity: float = -20.0
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 15.0

@onready var state_machine: StateMachine = $StateMachine

var pause: bool = false
var current_stamina: float = 100.0
var invincible: bool = false

func _ready() -> void:
	current_stamina = max_stamina

func get_character_gravity() -> Vector3:
	return Vector3(0, gravity, 0)

func _process(delta: float) -> void:
	if state_machine and state_machine.get("current_state"):
		if state_machine.current_state.name != "RunState":
			current_stamina = min(current_stamina + stamina_regen_rate * delta, max_stamina)
