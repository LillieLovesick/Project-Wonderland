extends Control

@onready var progress_bar = get_parent()

@onready var bar_width = progress_bar.size.x

func _ready() -> void:
	position.y = 25

func _physics_process(_delta: float) -> void:
	var ratio = progress_bar.value / progress_bar.max_value
	position.x = bar_width * ratio
	$GPUParticles2D.modulate = lerp(Color(0.65, 0.65, 0.65, 1.0), Color(1.0, 1.0, 1.0, 1.0), ratio)
