extends Control

@onready var player = $"../Player"

func _process(delta: float) -> void:
	if Globals.debug_mode == true:
		$Debug.visible = true
	else:
		$Debug.visible = false

func _on_player_health_update(health: int) -> void:
	$CanvasLayer/Health.text = "Health: "+str(health)

func _physics_process(delta: float) -> void:
	$Debug/VelocityTracker.text = "Velocity: "+str(player.velocity)
