class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
@export var character: CharacterBody3D

func _ready() -> void:
	await get_tree().process_frame
	
	if not character:
		push_error("A máquina de estados deve ser filha de um CharacterBody3D")
		return
	
	for child in get_children():
		if child is State:
			var key = child.name.to_lower()
			states[key] = child
			if key.ends_with("state"):
				states[key.replace("state", "")] = child
			child.state_machine = self
			child.character = character
	
	if initial_state:
		current_state = initial_state
		current_state.enter()
	elif states.size() > 0:
		current_state = states.values()[0]
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func transition_to(state_name: String) -> void:
	var new_state = states.get(state_name.to_lower())
	if not new_state or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
