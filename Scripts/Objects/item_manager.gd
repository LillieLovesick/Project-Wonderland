extends RigidBody3D

var can_interact = false
var player_inside = false
var is_target = false

@export var attatched_item: Item

@onready var target_manager = $"../../Player/TargetManager"
@onready var target_sprite = $"../../Player/TargetManager/TargetSprite"

var i_name: String
var i_desc: String
var i_rarity: int
var i_type: int

func _ready() -> void:
	i_name = attatched_item.item_name
	i_desc = attatched_item.item_description
	i_rarity = attatched_item.item_rarity
	i_type = attatched_item.item_type
	$Label3D.text = i_name + "\n" + i_desc + "\n" + str(i_rarity) + "\n" + str(i_type)
	
	match i_type:
		0:
			var model = attatched_item.model_path.instantiate()
			add_child(model)
			model.global_position = $TargetLocation.global_position
		1:
			pass
		2:
			$ItemModel.mesh = load("res://Assets/Models/SkillCard.fbx")

	var material = $BarrierEffect.get_active_material(0)
	match i_rarity:
		0:
			material.albedo_color = Color(1.0, 1.0, 1.0)
			$SparklesEffect.process_material.color = Color(7.29, 7.29, 7.29, 1.0)
		1:
			material.albedo_color = Color(0.375, 0.698, 1.0, 1.0)
			$SparklesEffect.process_material.color = Color(0.0, 4.377, 9.149, 1.0)
		2:
			material.albedo_color = Color(0.726, 0.375, 1.0, 1.0)
			$SparklesEffect.process_material.color = Color(6.074, 0.0, 9.149, 1.0)
		3:
			material.albedo_color = Color(1.705, 0.67, 0.0, 1.0)
			$SparklesEffect.process_material.color = Color(9.149, 5.009, 0.0, 1.0)
		4:
			material.albedo_color = Color(1.0, 0.296, 0.567, 1.0)
			$SparklesEffect.process_material.color = Color(9.149, 0.0, 4.154, 1.0)
	
	$BarrierEffect.set_surface_override_material(0, material)
	
func _physics_process(delta: float) -> void:
	$ItemModel.rotate_y(1 * delta)

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("interact") and player_inside == true:
			if is_target == true:
				PlayerData.Inventory.append(self.attatched_item)
				$TargetSprite.reparent(target_manager)
				queue_free()


func _on_interact_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_inside = true

func _on_interact_box_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_inside = false


func _on_child_entered_tree(node: Node) -> void:
	if node == target_sprite:
		is_target = true


func _on_child_exiting_tree(node: Node) -> void:
	if node == target_sprite:
		is_target = false
