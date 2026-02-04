extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Equipped.weapon = load("res://Skills/sword_basic.tres")
	Equipped.skill_1 = load("res://Skills/sword_skill_dash.tres")
