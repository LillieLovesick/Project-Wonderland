extends CanvasLayer

@onready var Menus = $Menus
@onready var HUD = $HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Menus.visible = false
	HUD.visible = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		get_tree().paused = !get_tree().paused
		Menus.visible = !Menus.visible
		HUD.visible = !HUD.visible
		Globals.menu_open = Menus.visible
		
		if Globals.menu_open == true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
