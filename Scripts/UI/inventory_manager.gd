extends Control

var held_weapons: Array
var held_armor: Array
var held_skills: Array

var skill_selected = false

@export var back_action: String

@export_category("References")
@export var weapons_list: ItemList
@export var armor_list: ItemList
@export var skill_list: ItemList

@export var WeaponLabel: RichTextLabel
@export var ArmorLabel: RichTextLabel
@export var SkillLabel: RichTextLabel

@export var Skill1_slot: TextureProgressBar
@export var Skill2_slot: TextureProgressBar
@export var Skill3_slot: TextureProgressBar
@export var skills_animator: AnimationPlayer

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
		
	Skill1_slot.texture_under = PlayerData.skill_1.skill_texture
	Skill2_slot.texture_under = PlayerData.skill_2.skill_texture
	Skill3_slot.texture_under = PlayerData.skill_3.skill_texture

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

func _on_armor_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	held_armor.append(PlayerData.armor)
	PlayerData.armor = held_armor[index]
	held_armor.erase(PlayerData.armor)
	inventory_update()
	inventory_refresh()

func _on_skill_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	skills_animator.play("skill_selected")
	skill_selected = index

func _on_skill_list_focus_exited() -> void:
	skill_list.deselect_all()
	skills_animator.play("RESET")
	skill_selected = null

func _on_armor_list_focus_exited() -> void:
	armor_list.deselect_all()

func _on_weapons_list_focus_exited() -> void:
	weapons_list.deselect_all()

func _on_skill_1_clicked(_event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and skill_selected != null:
		held_skills.append(PlayerData.skill_1)
		PlayerData.skill_1 = held_skills[skill_selected]
		held_skills.erase(PlayerData.skill_1)
		inventory_update()
		inventory_refresh()

func _on_skill_2_clicked(_event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and skill_selected != null:
		held_skills.append(PlayerData.skill_2)
		PlayerData.skill_2 = held_skills[skill_selected]
		held_skills.erase(PlayerData.skill_2)
		inventory_update()
		inventory_refresh()

func _on_skill_3_clicked(_event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and skill_selected != null:
		held_skills.append(PlayerData.skill_3)
		PlayerData.skill_3 = held_skills[skill_selected]
		held_skills.erase(PlayerData.skill_3)
		inventory_update()
		inventory_refresh()
