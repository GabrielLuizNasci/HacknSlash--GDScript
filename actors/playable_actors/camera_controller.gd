extends Node3D

@export var follow_speed: float = 10.0
@export var h_sensit: float = 0.003
@export var v_sensit: float = 0.003
@export var h_accel: float = 11.0
@export var v_accel: float = 11.0
@export var cam_v_max_deg: float = 55.0
@export var cam_v_min_deg: float = -55.0
@export var capture_mouse_on_ready: bool = true

@onready var h_pivot: Node3D = $H
@onready var v_spring_arm: Node3D = $H/V
@onready var character_chamera: Camera3D = $H/V/CharacterController

var is_mouse_captured: bool = true
var cam_rotat_h: float = 0.0
var cam_rotat_v: float = 0.0

func _ready() -> void:
	cam_rotat_h = h_pivot.rotation.y
	cam_rotat_v = v_spring_arm.rotation.x
	is_mouse_captured = capture_mouse_on_ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_mouse_captured else Input.MOUSE_MODE_VISIBLE
	

func _physics_process(delta: float) -> void:
	var parent := get_parent() as Node3D
	if parent:
		global_position = global_position.lerp(parent.global_position, follow_speed * delta)
	
	cam_rotat_v = clamp(cam_rotat_v, deg_to_rad(cam_v_min_deg), deg_to_rad(cam_v_max_deg))
	
	h_pivot.rotation.y = lerpf(h_pivot.rotation.y, cam_rotat_h, delta * h_accel)
	v_spring_arm.rotation.x = lerpf(v_spring_arm.rotation.x, cam_rotat_v, delta * v_accel)

func _input(event: InputEvent) -> void:
		if event is InputEventMouseMotion and is_mouse_captured:
			cam_rotat_h += -event.relative.x * h_sensit
			cam_rotat_v += event.relative.y * v_sensit
		if event.is_action_pressed("toggle_mouse_capture"):
			switch_mouse()

func switch_mouse() -> void:
	is_mouse_captured = not is_mouse_captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_mouse_captured else Input.MOUSE_MODE_VISIBLE
