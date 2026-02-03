extends Node3D

signal cameraChange(mode: String)
signal targetUpdate(target: Object)

@onready var player := get_parent()
@onready var target_indicator = $TargetSprite
@onready var target_indicator_anims = $TargetSprite/AnimationPlayer

var closest_target_dist = INF
var target_list: Array[Node3D]
var is_targeting := false
var target_count = 0
var last_target: Object
var target: Object

func _physics_process(delta: float) -> void:
	if is_targeting == false:
		findClosestTarget()
		setTarget()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if target:
			is_targeting = true
			targetUpdate.emit(target)
			target_indicator_anims.play("lock_on")
		
	if event.is_action_released("right_click"):
		is_targeting = false
		targetUpdate.emit(null)
		target_indicator_anims.play("RESET")

func findClosestTarget():
	if target_list.is_empty() == true:
		target = null
	for entity in target_list:
		$Raycast3D.set_target_position(entity.global_position)
		$Raycast3D.force_raycast_update()
		if $Raycast3D.get_collider() != null:
			target_list.erase(entity)
		else:
			var distance = entity.global_position.distance_squared_to(self.global_position)
			if distance < closest_target_dist:
				target = entity
				closest_target_dist = distance
	closest_target_dist = INF
	$Raycast3D.set_target_position(Vector3(0.0,0.0,0.1))

func setTarget():
	if target:
		target_indicator.reparent(target)
		target_indicator.visible = true
		var target_location = target.get_node("TargetLocation")
		target_indicator.position = target_location.position
		target_indicator.scale = target_location.scale
	else:
		target_indicator.reparent(self)
		target_indicator.visible = false
		target_indicator.position = self.position
		target_indicator.scale = Vector3(0.1, 0.1, 0.1)

func _on_target_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		target_list.append(body)

func _on_target_area_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		target_list.erase(body)
		if body == target:
			cameraChange.emit("MMO")
			is_targeting = false
			targetUpdate.emit(null)
		if is_targeting == false:
			findClosestTarget()
			setTarget()
