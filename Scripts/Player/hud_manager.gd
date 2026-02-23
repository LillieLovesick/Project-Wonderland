extends Control

@onready var player = $"../Player"
@onready var weapon = $"../Player/CharaModel/Weapon"
@onready var target_manager = $"../Player/TargetManager"

@onready var timer1 = $CanvasLayer/Skills/Skill1/Timer
@onready var timer2 = $CanvasLayer/Skills/Skill2/Timer
@onready var timer3 = $CanvasLayer/Skills/Skill3/Timer

@onready var item_name = $CanvasLayer/ItemDialogue/MarginContainer/VBoxContainer/HBoxContainer/ItemName
@onready var item_type = $CanvasLayer/ItemDialogue/MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var item_rarity = $CanvasLayer/ItemDialogue/MarginContainer/VBoxContainer/Rarity

var tween
var active_skill_timer = false


signal cooldown_end(skill: int)

func _ready() -> void:
	update_skills()	
	weapon.skill_started.connect(_on_skill_start)
	weapon.skill_used.connect(_on_skill_used)
	target_manager.itemTargeted.connect(_on_item_targeted)
	$CanvasLayer/Health.max_value = PlayerData.max_health
	$CanvasLayer/Health.value = PlayerData.health

func _process(delta: float) -> void:
	pass

func update_skills() -> void:
	$CanvasLayer/Skills/Skill1.texture_under = PlayerData.skill_1.skill_texture
	$CanvasLayer/Skills/Skill2.texture_under = PlayerData.skill_2.skill_texture
	$CanvasLayer/Skills/Skill3.texture_under = PlayerData.skill_3.skill_texture

func _on_player_health_update(health: int) -> void:
	if health < $CanvasLayer/Health.value:
		$CanvasLayer/Health/HealthParticles/GPUParticles2D.restart()
	tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Health, "value", health, 0.12)
	$CanvasLayer/Health/HealthText.text = str(health)

func _physics_process(delta: float) -> void:
	if timer1.time_left > 0:
		$CanvasLayer/Skills/Skill1.value = timer1.time_left
	if timer2.time_left > 0:
		$CanvasLayer/Skills/Skill2.value = timer2.time_left
	if timer3.time_left > 0:
		$CanvasLayer/Skills/Skill3.value = timer3.time_left

func _on_skill_used(skill: int) -> void:
	match skill:
		1:
			$CanvasLayer/Skills/Skill1.max_value = PlayerData.skill_1.skill_cooldown
			timer1.wait_time = PlayerData.skill_1.skill_cooldown
			timer1.start()
		2:
			$CanvasLayer/Skills/Skill2.max_value = PlayerData.skill_2.skill_cooldown
			timer2.wait_time = PlayerData.skill_2.skill_cooldown
			timer2.start()
		3:
			$CanvasLayer/Skills/Skill3.max_value = PlayerData.skill_3.skill_cooldown
			timer3.wait_time = PlayerData.skill_3.skill_cooldown
			timer3.start()

func _on_skill_start(skill: int) -> void:
	match skill:
		1:
			$CanvasLayer/Skills/Skill1.value = $CanvasLayer/Skills/Skill1.max_value
		2:
			$CanvasLayer/Skills/Skill2.value = $CanvasLayer/Skills/Skill2.max_value
		3:
			$CanvasLayer/Skills/Skill3.value = $CanvasLayer/Skills/Skill3.max_value

func _on_skill1_timeout() -> void:
	cooldown_end.emit(1)
	timer1.stop()

func _on_skill2_timeout() -> void:
	cooldown_end.emit(2)
	timer2.stop()

func _on_skill3_timeout() -> void:
	cooldown_end.emit(3)
	timer3.stop()
	
func _on_item_targeted(target: Object) -> void:
	if target:
		tween = get_tree().create_tween()
		tween.tween_property($CanvasLayer/ItemDialogue,"position",Vector2(1.0, 0.0),0.1)
		ItemBoxUpdate(target)
	else:
		tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($CanvasLayer/ItemDialogue,"position",Vector2(1.0, -85.0),0.05)
		
		
func ItemBoxUpdate(item: Object) -> void:
	item_name.text = item.attatched_item.item_name
	match item.attatched_item.item_rarity:
		0:
			item_rarity.text = "Common"
			item_rarity.label_settings.font_color = Color(0.62, 0.62, 0.62, 1.0)
		1:
			item_rarity.text = "Rare"
			item_rarity.label_settings.font_color = Color(0.375, 0.698, 1.0, 1.0)
		2:
			item_rarity.text = "Epic"
			item_rarity.label_settings.font_color = Color(0.726, 0.375, 1.0, 1.0)
		3:
			item_rarity.text = "Legendary"
			item_rarity.label_settings.font_color = Color(1.705, 0.67, 0.0, 1.0)
		4:
			item_rarity.text = "UNBEATABLE"
			item_rarity.label_settings.font_color = Color(1.0, 0.296, 0.567, 1.0)
	
	match item.attatched_item.item_type:
		0:
			item_type.texture = load("res://Assets/HUD/weaponIcon.png")
		1:
			item_type.texture = load("res://Assets/HUD/armorIcon.png")
		2:
			item_type.texture = load("res://Assets/HUD/cardIcon.png")
