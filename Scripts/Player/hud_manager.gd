extends Control

@onready var player = $"../Player"

var tween

func _ready() -> void:
	$CanvasLayer/Health.max_value = PlayerData.max_health
	$CanvasLayer/Health.value = PlayerData.health

func _process(delta: float) -> void:
	if Globals.debug_mode == true:
		$CanvasLayer/Debug.visible = true
	else:
		$CanvasLayer/Debug.visible = false

func _on_player_health_update(health: int) -> void:
	if health < $CanvasLayer/Health.value:
		$CanvasLayer/Health/HealthParticles/GPUParticles2D.restart()
	tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Health, "value", health, 0.12)
	$CanvasLayer/HealthText.text = str(health)

func _physics_process(delta: float) -> void:
	$CanvasLayer/Debug/VelocityTracker.text = "Velocity: "+str(player.velocity)
