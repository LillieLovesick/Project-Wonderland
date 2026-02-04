extends Control

func _process(delta: float) -> void:
	if Globals.debug_mode == true:
		$Debug.visible = true
	else:
		$Debug.visible = false

func _on_player_health_update(health: int) -> void:
	$CanvasLayer/Health.text = "Health: "+str(health)
