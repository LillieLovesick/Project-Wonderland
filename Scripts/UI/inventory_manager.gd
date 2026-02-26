extends Control

var held_weapons: Array
var held_armor: Array
var held_skills: Array

@export var back_action: String

@export_category("References")
@export var weapons_list: ItemList
@export var armor_list: ItemList
@export var skill_list: ItemList

@export var WeaponLabel: RichTextLabel
@export var ArmorLabel: RichTextLabel
@export var SkillLabel: RichTextLabel

func inventory_refresh() -> void:
	weapons_list.clear()
	held_weapons.clear()
	armor_list.clear()
	held_armor.clear()
	skill_list.clear()
	held_skills.clear()
	
	
	for item in PlayerData.Inventory:
		match item.item_type:
			0:
				weapons_list.add_item(item.item_name, preload("res://Assets/HUD/weaponIcon.png"))
				held_weapons.append(item)
			1:
				armor_list.add_item(item.item_name, preload("res://Assets/HUD/armorIcon.png"))
				held_armor.append(item)
			2:
				skill_list.add_item(item.item_name, preload("res://Assets/HUD/cardIcon.png"))
				held_skills.append(item)
				
	WeaponLabel.text = "Weapons ("+str(weapons_list.item_count)+")"
	ArmorLabel.text = "Armor ("+str(armor_list.item_count)+")"
	SkillLabel.text = "Skills ("+str(skill_list.item_count)+")"

func inventory_update() -> void:
	PlayerData.Inventory.clear()
	
	for item in held_weapons:
		PlayerData.Inventory.append(item)
	for item in held_armor:
		PlayerData.Inventory.append(item)
	for item in held_skills:
		PlayerData.Inventory.append(item)

func _on_visibility_changed() -> void:
	if visible:
		inventory_refresh()
	else:
		inventory_update()

func _on_weapons_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	held_weapons.append(PlayerData.weapon)
	PlayerData.weapon = held_weapons[index]
	held_weapons.erase(PlayerData.weapon)
	inventory_update()
	inventory_refresh()

func _on_armor_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	held_armor.append(PlayerData.armor)
	PlayerData.armor = held_armor[index]
	held_armor.erase(PlayerData.weapon)
	inventory_update()
	inventory_refresh()


func _on_skill_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var stored_item = held_armor[index]
