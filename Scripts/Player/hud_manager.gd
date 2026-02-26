extends Control

@onready var player = $"../../Player"
@onready var weapon = $"../../Player/Character/Weapon"
@onready var target_manager = $"../../Player/TargetManager"

@onready var timer1 = $"../../Player/Character/Weapon/Skill1Cooldown"
@onready var timer2 = $"../../Player/Character/Weapon/Skill2Cooldown"
@onready var timer3 = $"../../Player/Character/Weapon/Skill3Cooldown"

@onready var item_name = $ItemDialogue/MarginContainer/VBoxContainer/HBoxContainer/ItemName
@onready var item_type = $ItemDialogue/MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var item_rarity = $ItemDialogue/MarginContainer/VBoxContainer/Rarity

var tween

func _ready() -> void:
	update_skills()
	target_manager.itemTargeted.connect(_on_item_targeted)
	$Health.max_value = PlayerData.max_health
	$Health.value = PlayerData.health

func update_skills() -> void:
	$Skills/Skill1.texture_under = PlayerData.skill_1.skill_texture
	$Skills/Skill1.max_value = PlayerData.skill_1.skill_cooldown
	
	$Skills/Skill2.texture_under = PlayerData.skill_2.skill_texture
	$Skills/Skill2.max_value = PlayerData.skill_2.skill_cooldown
	
	$Skills/Skill3.texture_under = PlayerData.skill_3.skill_texture
	$Skills/Skill3.max_value = PlayerData.skill_3.skill_cooldown

func _on_player_health_update(health: int) -> void:
	if health < $Health.value:
		$Health/HealthParticles/GPUParticles2D.restart()
	tween = get_tree().create_tween()
	tween.tween_property($Health, "value", health, 0.12)
	$Health/HealthText.text = str(health)

func _physics_process(_delta: float) -> void:
	if timer1.time_left > 0:
		$Skills/Skill1.value = timer1.time_left
	if timer2.time_left > 0:
		$Skills/Skill2.value = timer2.time_left
	if timer3.time_left > 0:
		$Skills/Skill3.value = timer3.time_left
	
func _on_item_targeted(target: Object) -> void:
	if target:
		tween = get_tree().create_tween()
		tween.tween_property($ItemDialogue,"position",Vector2(1.0, 0.0),0.1)
		ItemBoxUpdate(target)
	else:
		tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($ItemDialogue,"position",Vector2(1.0, -85.0),0.05)
		
		
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
