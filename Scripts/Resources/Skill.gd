class_name Skill
extends Resource

@export var attack_name: String
@export var attack_description: String
@export_enum ("Basic", "Ability") var skill_type: int
@export_enum ("Melee", "Ranged") var weapon_type: int
@export var model_path: String
@export var skill_animation: String

@export_group("Melee weapon settings")
@export var attack_damage: int

@export_group("Ranged weapon settings")
@export var projectile: PackedScene
@export var projectile_damage: int
