class_name Skill
extends Item

@export_group("Skill Setup")
@export var attack_name: String
@export_multiline() var attack_description: String
@export_enum ("Melee", "Ranged", "Hybrid") var weapon_type: int
@export var weapon_class: String
@export_enum ("1","2","3") var slot_lock: int
@export_subgroup("Skill Details")
@export var skill_cooldown: float
@export var skill_animation: String
@export var skill_texture: Texture
@export var skill_potency: int
@export_subgroup("Projectile Setup")
@export var projectile: PackedScene
@export var projectile_damage: int
