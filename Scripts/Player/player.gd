extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export_enum ("MMO", "OTS") var camera_mode: int
@export var zoom_speed := 0.1

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 10.0
@export var deceleration := 75.0
@export var rotation_speed := 12.0
@export var jump_strength := 12.0

@onready var _camera_pivot: Node3D = %CamPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _character: MeshInstance3D = %CharaModel

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var _gravity := -30.0
var move_direction
var tween
var camera_snapped

func _ready() -> void:
	if camera_mode == 0:
		$CamPivot/SpringArm3D.spring_length = 8.0
		$CamPivot/SpringArm3D.position.x = 0.0
	elif camera_mode == 1:
		$CamPivot/SpringArm3D.spring_length = 2.0
		$CamPivot/SpringArm3D.position.x = -1.2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("right_click"):
		camera_mode = 1
		camera_snapped = false
	if event.is_action_released("right_click"):
		camera_mode = 0
		camera_snapped = false
		
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _process(delta: float) -> void:
	if camera_mode == 0:
		_camera_pivot.rotation.x += _camera_input_direction.y * delta
		_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x,-PI / 6.0, PI / 3.0)
		_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	if camera_mode == 1:
		_camera_pivot.rotation.x += _camera_input_direction.y * delta
		_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x,-PI / 6.0, PI / 3.0)
		_camera_pivot.rotation.y -= _camera_input_direction.x * delta
		_character.rotation_degrees.y = _camera_pivot.rotation_degrees.y
		
	_camera_input_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if camera_mode == 0 and camera_snapped == false:
		tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($CamPivot/SpringArm3D, "spring_length", 8.0, zoom_speed)
		tween.tween_property($CamPivot/SpringArm3D, "position", Vector3(0.0, 0.0, 0.0), zoom_speed)
		camera_snapped = true
		
	elif camera_mode == 1 and camera_snapped == false:
		tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($CamPivot/SpringArm3D, "spring_length", 2.0, zoom_speed)
		tween.tween_property($CamPivot/SpringArm3D, "position", Vector3(-1.2, 0.0, 0.0), zoom_speed)
		camera_snapped = true

	var raw_input := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x

	move_direction = forward * raw_input.y + right * raw_input.x
	move_direction.y =  0.0
	move_direction = move_direction.normalized()
		
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	#MMO Camera Character Rotation
	if camera_mode == 0:
		var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
		_character.global_rotation.y = lerp_angle(_character.rotation.y, target_angle, rotation_speed * delta)
	
	#Jump Movement
	var y_velocity := velocity.y
	velocity.y = 0.0
	if raw_input:
		velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(move_direction * move_speed, deceleration * delta)
	velocity.y = y_velocity + _gravity * delta
	
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_strength
	
	move_and_slide()
