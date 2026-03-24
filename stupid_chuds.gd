@tool
class_name chuds
extends Node
var messed_up : int = 1
var chud_win : int = 1
@export var ruin_everything : Node3D
@export var fun : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand = randf_range(0.1, 10)
	if !Engine.is_editor_hint() and ruin_everything and fun:
		for x in ruin_everything.get_script().get_script_property_list():
			var thing = ruin_everything.get(x.name)
			if thing is int or thing is float:
				ruin_everything.set(x.name,thing * rand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Engine.is_editor_hint() and ruin_everything and !fun:
		for x in ruin_everything.get_script().get_script_property_list():
			var thing = ruin_everything.get(x.name)
			if thing is int or thing is float:
				ruin_everything.set(x.name,randf_range(-100, 100))
	if Input.is_action_just_pressed("ui_text_backspace"):
		print("stupid chud messed up, times messed up: ",str(messed_up))
		messed_up += 1
	if Input.is_action_just_pressed("ui_accept"):
		print("Hurray you did it, stupid chud success: ",str(chud_win))
		chud_win += 1
