class_name Skill
extends Resource

@export var attack_name: String
@export var attack_description: String
@export var skill_cooldown: float
@export_enum ("Melee", "Ranged") var weapon_type: int
@export var model_path: PackedScene
@export var skill_animation: String
@export var skill_texture: Texture

@export_group("Melee weapon settings")
@export var attack_damage: int

@export_group("Ranged weapon settings")
@export var projectile: PackedScene
@export var projectile_damage: int
