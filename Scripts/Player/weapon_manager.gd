extends Node3D

var is_playing = false
var attack_type: String
var target = null

@onready var anim_player = %PlayerAnims
@onready var target_manager = %TargetManager

func _ready() -> void:
	$WeaponModel.mesh = load(Equipped.weapon.model_path)

func animation_play(animation) -> void:
	is_playing = true
	anim_player.play(animation)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if is_playing == false:
			attack_type = "Basic"
			animation_play(Equipped.weapon.skill_animation)
	if event.is_action_pressed("skill_1"):
		if is_playing == false and Equipped.skill_1 != null:
			attack_type = "Skill_1"
			animation_play(Equipped.skill_1.skill_animation)
	if event.is_action_pressed("skill_2"):
		if is_playing == false and Equipped.skill_2 != null:
			attack_type = "Skill_2"
			animation_play(Equipped.skill_2.skill_animation)
	if event.is_action_pressed("skill_3"):
		if is_playing == false and Equipped.skill_3 != null:
			attack_type = "Skill_3"
			animation_play(Equipped.skill_3.skill_animation)

func _on_animation_finished(_anim_name: StringName) -> void:
	is_playing = false
	anim_player.play("RESET")


func _on_weapon_hitbox_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		match attack_type:
			"Basic":
				body.damage(Equipped.weapon.attack_damage)
			"Skill_1":
				body.damage(Equipped.skill_1.attack_damage)
			"Skill_2":
				body.damage(Equipped.skill_2.attack_damage)
			"Skill_3":
				body.damage(Equipped.skill_3.attack_damage)
