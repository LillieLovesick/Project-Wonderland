extends Node3D

var is_playing = false
var attack_type: int
var target = null
var model: Node

var s1_on_cooldown = false
var s2_on_cooldown = false
var s3_on_cooldown = false

@onready var anim_player = %PlayerAnims
@onready var target_manager = %TargetManager

func _ready() -> void:
	weapon_update(0)
	skill_update()

func weapon_update(skill: int) -> void:
	var loadedWeapon
	if model != null:
		model.queue_free()
	match skill:
		0:
			model = PlayerData.weapon.model_path.instantiate()
		1:
			model = PlayerData.skill_1.model_path.instantiate()
		2:
			model = PlayerData.skill_2.model_path.instantiate()
		3:
			model = PlayerData.skill_3.model_path.instantiate()
	add_child(model)
	model.global_transform = $"../PlayerModel/RightHand".global_transform
	
func skill_update() -> void:
	$Skill1Cooldown.wait_time = PlayerData.skill_1.skill_cooldown
	$Skill2Cooldown.wait_time = PlayerData.skill_2.skill_cooldown
	$Skill3Cooldown.wait_time = PlayerData.skill_3.skill_cooldown
	
func animation_play(animation) -> void:
	is_playing = true
	anim_player.play(animation)

func _input(event: InputEvent) -> void:
	if Globals.menu_open == false:
		if event.is_action_pressed("left_click"):
			if is_playing == false:
				attack_type = 0
				weapon_update(0)
				animation_play(PlayerData.weapon.skill_animation)
		if event.is_action_pressed("skill_1"):
			if is_playing == false and s1_on_cooldown == false and PlayerData.skill_1 != null:
				attack_type = 1
				weapon_update(1)
				$Skill1Cooldown.start()
				animation_play(PlayerData.skill_1.skill_animation)
				s1_on_cooldown = true
		if event.is_action_pressed("skill_2"):
			if is_playing == false and s2_on_cooldown == false and  PlayerData.skill_2 != null:
				attack_type = 2
				weapon_update(2)
				$Skill2Cooldown.start()
				animation_play(PlayerData.skill_2.skill_animation)
				s2_on_cooldown = true
		if event.is_action_pressed("skill_3"):
			if is_playing == false and s3_on_cooldown == false and PlayerData.skill_3 != null:
				attack_type = 3
				weapon_update(3)
				$Skill3Cooldown.start()
				animation_play(PlayerData.skill_3.skill_animation)
				s3_on_cooldown = true

func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name != "RESET":
		is_playing = false
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
				
func skill_cancellable(skill: int) -> void:
	match skill:
		1:
			s1_on_cooldown = false
		2:
			s2_on_cooldown = false
		3:
			s3_on_cooldown = false


func skill_1_cd_end() -> void:
	s1_on_cooldown = false

func skill_2_cd_end() -> void:
	s2_on_cooldown = false

func skill_3_cd_end() -> void:
	s3_on_cooldown = false
