class_name State extends Node

signal state_finished(next_state_name: String)

@export var animation_name: String = ""
@export var can_move: bool = true

var character: CharacterBody3D
var state_machine: StateMachine
var animation_tree: AnimationTree
var animation_player: AnimationNodeStateMachinePlayback
var input_controller

func enter() -> void:
	if animation_name != "" and animation_player:
		animation_player.travel(animation_name) 

func exit() -> void:
	pass 

func update(_delta: float) -> void:
	pass  

func physics_update(_delta: float) -> void:
	pass  
