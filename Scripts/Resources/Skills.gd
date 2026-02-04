class_name Skill
extends Resource

@export var attack_name: String
@export_enum ("Basic", "Ability") var skill_type: int
@export_enum ("Melee", "Ranged") var weapon_type: int
@export var model_path: String
@export var skill_animation: String

@export_group("Melee weapon settings")
@export var attack_damage: int

@export_group("Ranged weapon settings")
@export var projectile: PackedScene
@export var projectile_damage: int

@export_group("Ability settings")
@export_enum ("Disabled","1","2","3") var slot_lock: int = 0
@export_enum ("Disabled","Sword","Gun") var weapon_lock: String = "Disabled"
