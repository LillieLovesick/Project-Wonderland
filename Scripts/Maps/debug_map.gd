extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Equipped.weapon = load("res://Weapons/w_sword_default.tres")
	Equipped.skill_1 = load("res://Skills/s_sword_dash.tres")
