extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.weapon = load("res://Weapons/w_sword_default.tres")
	PlayerData.skill_1 = load("res://Skills/s_sword_dash.tres")
	PlayerData.skill_2 = load("res://Skills/s_sword_pogo.tres")
	PlayerData.skill_3 = load("res://Skills/s_sword_fakeout.tres")
	PlayerData.max_health = 100
	PlayerData.health = 100
