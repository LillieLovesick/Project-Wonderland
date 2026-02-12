class_name Item
extends Resource

@export_group("Item Info")
@export var item_name: String
@export var item_description: String
@export_enum ("Common","Rare","Epic","Legendary","UNBEATABLE") var item_rarity: int
@export_enum ("Weapon","Armor","Skill Card") var item_type: int

@export_group("Weapon Setup")
@export var attack_name: String
@export_enum ("Melee", "Ranged") var weapon_type: int
@export var model_path: String
@export var skill_animation: String
@export var attack_damage: int
@export var projectile: PackedScene
@export var projectile_damage: int

@export_group("Armor Setup")
@export var defense: int
@export_enum ("Head", "Torso", "Legs", "Boots") var Slot: String
@export var shiny_colour: Color

@export_group("Skill Card Setup")
@export var linked_skill: Skill
