class_name Item
extends Resource

@export_group("Item Info")
@export var item_name: String
@export var item_description: String
@export_enum ("Common","Rare","Epic","Legendary","UNBEATABLE") var item_rarity: int
@export_enum ("Weapon","Armor","Skill Card") var item_type: int
@export var model_path: PackedScene
