extends Control

@onready var player = $"../Player"
@onready var weapon = $"../Player/CharaModel/Weapon"

@onready var timer1 = $CanvasLayer/Skills/Skill1/Timer
@onready var timer2 = $CanvasLayer/Skills/Skill2/Timer
@onready var timer3 = $CanvasLayer/Skills/Skill3/Timer

var tween
var active_skill_timer = false

signal cooldown_end(skill: int)

func _ready() -> void:
	weapon.skill_started.connect(_on_skill_start)
	weapon.skill_used.connect(_on_skill_used)
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
	$CanvasLayer/Health/HealthText.text = str(health)

func _physics_process(delta: float) -> void:
	$CanvasLayer/Debug/VelocityTracker.text = "Velocity: "+str(player.velocity)
	if timer1.time_left > 0:
		print($CanvasLayer/Skills/Skill1.value)
		$CanvasLayer/Skills/Skill1.value = timer1.time_left
	if timer2.time_left > 0:
		$CanvasLayer/Skills/Skill2.value = timer2.time_left
	if timer3.time_left > 0:
		$CanvasLayer/Skills/Skill3.value = timer3.time_left

func _on_skill_used(skill: int) -> void:
	match skill:
		1:
			$CanvasLayer/Skills/Skill1.max_value = PlayerData.skill_1.skill_cooldown
			timer1.wait_time = PlayerData.skill_1.skill_cooldown
			timer1.start()
		2:
			$CanvasLayer/Skills/Skill2.max_value = PlayerData.skill_2.skill_cooldown
			timer2.wait_time = PlayerData.skill_2.skill_cooldown
			timer2.start()
		3:
			$CanvasLayer/Skills/Skill3.max_value = PlayerData.skill_3.skill_cooldown
			timer3.wait_time = PlayerData.skill_3.skill_cooldown
			timer3.start()

func _on_skill_start(skill: int) -> void:
	match skill:
		1:
			$CanvasLayer/Skills/Skill1.value = $CanvasLayer/Skills/Skill1.max_value
		2:
			$CanvasLayer/Skills/Skill2.value = $CanvasLayer/Skills/Skill2.max_value
		3:
			$CanvasLayer/Skills/Skill3.value = $CanvasLayer/Skills/Skill3.max_value

func _on_skill1_timeout() -> void:
	cooldown_end.emit(1)
	timer1.stop()

func _on_skill2_timeout() -> void:
	cooldown_end.emit(2)
	timer2.stop()

func _on_skill3_timeout() -> void:
	cooldown_end.emit(3)
	timer3.stop()
