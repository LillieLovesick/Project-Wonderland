class_name Skill
extends Item

@export_group("Skill Setup")
@export var attack_name: String
@export var attack_description: String
@export var skill_cooldown: float
@export_enum ("Melee", "Ranged", "Hybrid") var weapon_type: int
@export var skill_animation: String
@export var skill_texture: Texture
@export var skill_potency: int
@export var projectile: PackedScene
@export var projectile_damage: int
