extends Node3D

signal cameraChange(mode: String)
signal targetUpdate(target: Object)
signal itemTargeted(target: Object)

@onready var player := get_parent()
@onready var target_indicator = $TargetSprite
@onready var target_indicator_anims = $TargetSprite/AnimationPlayer
@onready var line_of_sight = $"../CamPivot/Raycast3D"

var nearest_distance: float
var current_distance: float
var target_list: Array[Node3D] = []
var is_targeting = false
var nearest_index: int
var target: Object
var last_target
var is_returning = false
var target_delay = false

func _physics_process(delta: float) -> void:
	if is_targeting == false and is_returning == false:
		target = findClosestTarget()
		setTarget()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if target and target.can_interact == true:
			is_targeting = true
			targetUpdate.emit(target)
			target_indicator_anims.play("lock_on")
		
	if event.is_action_released("right_click"):
		is_targeting = false
		targetUpdate.emit(null)
		target_indicator_anims.play("RESET")
		
	if event.is_action_pressed("retarget"):
		if is_targeting == true:
			target = findClosestTarget(target)
			if target != null:
				if target.can_interact == true:
					setTarget()
					targetUpdate.emit(target)

func findClosestTarget(current_target: Node3D = null) -> Node3D:
	nearest_index = -1
	nearest_distance = INF
	
	if target_list.size() == 0:
		return null
	for i in target_list.size():
		if is_targeting == true and target_list[i] == current_target and target_list.size() > 1 or target_list[i].is_in_group("Player"):
			continue
		current_distance = player.global_position.distance_squared_to(target_list[i].global_position)
		if current_distance < nearest_distance:
			line_of_sight.global_rotation = Vector3.ZERO
			line_of_sight.target_position = target_list[i].global_position - global_position
			line_of_sight.force_raycast_update()
			if line_of_sight.get_collider() == target_list[i]:
				nearest_distance = current_distance
				nearest_index = i
	if nearest_index == -1:
		return null
	else:
		return target_list[nearest_index]

func setTarget() -> void:
	if is_instance_valid(target) and target_delay == false:
		target_indicator.reparent(target)
		target_indicator.visible = true
		var target_location = target.get_node("TargetLocation")
		target_indicator.position = target_location.position
		target_indicator.scale = target_location.scale
		if target.is_in_group("Items"):
			itemTargeted.emit(target)
		else:
			itemTargeted.emit(null)
	else:
		target_indicator.reparent(self)
		target_indicator.visible = false
		target_indicator.position = self.position
		target_indicator.scale = Vector3(0.1, 0.1, 0.1)
		itemTargeted.emit(null)

func _on_target_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		target_list.append(body)

func _on_target_area_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		target_list.erase(body)
		if body == target:
			cameraChange.emit("MMO")
			target_indicator_anims.play("RESET")
			is_targeting = false
			targetUpdate.emit(null)

func _on_child_entered_tree(node: Node) -> void:
	if node == $TargetSprite:
		target_delay = true
		await get_tree().process_frame
		target_delay = false
