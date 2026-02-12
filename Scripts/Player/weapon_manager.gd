extends Node3D

signal skill_started(skill: int)
signal skill_used(skill: int)

var is_playing = false
var attack_type: int
var target = null

var s1_on_cooldown = false
var s2_on_cooldown = false
var s3_on_cooldown = false

@onready var anim_player = %PlayerAnims
@onready var target_manager = %TargetManager
@onready var HUD = get_tree().get_root().get_node("World/HUD")

func _ready() -> void:
	HUD.cooldown_end.connect(_on_cooldown_end)
	weapon_update()

func weapon_update():
	$WeaponModel.mesh = load(PlayerData.weapon.model_path)

func animation_play(animation) -> void:
	is_playing = true
	anim_player.play(animation)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if is_playing == false:
			attack_type = 0
			animation_play(PlayerData.weapon.skill_animation)
	if event.is_action_pressed("skill_1"):
		if is_playing == false and s1_on_cooldown == false and PlayerData.skill_1 != null:
			attack_type = 1
			skill_started.emit(1)
			animation_play(PlayerData.skill_1.skill_animation)
			s1_on_cooldown = true
	if event.is_action_pressed("skill_2"):
		if is_playing == false and s2_on_cooldown == false and  PlayerData.skill_2 != null:
			attack_type = 2
			skill_started.emit(2)
			animation_play(PlayerData.skill_2.skill_animation)
			s2_on_cooldown = true
	if event.is_action_pressed("skill_3"):
		if is_playing == false and s3_on_cooldown == false and PlayerData.skill_3 != null:
			attack_type = 3
			skill_started.emit(3)
			animation_play(PlayerData.skill_3.skill_animation)
			s3_on_cooldown = true

func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name != "RESET":
		is_playing = false
		skill_used.emit(attack_type)
		anim_player.play("RESET")


func _on_weapon_hitbox_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		match attack_type:
			0:
				body.damage(PlayerData.weapon.attack_damage)
			1:
				body.damage(PlayerData.skill_1.attack_damage)
			2:
				body.damage(PlayerData.skill_2.attack_damage)
			3:
				body.damage(PlayerData.skill_3.attack_damage)
				
func _on_cooldown_end(skill: int) -> void:
	match skill:
		1:
			s1_on_cooldown = false
		2:
			s2_on_cooldown = false
		3:
			s3_on_cooldown = false
