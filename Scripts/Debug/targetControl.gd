extends CharacterBody3D

@export_group("Setup")
@export_enum ("Dummy", "Movement", "Combat", "Movement + Combat") var dummy_type: int
@export var can_interact: bool
@export var health: int = 3
@export var defense: int = 0

@export_subgroup("Movement Options")
@export_enum ("Strafing", "Jumping", "Strafe + Jump", "Random") var movement_type: int
@export var move_speed := 8.0
@export var acceleration := 10.0
@export var deceleration := 75.0
@export var jump_strength := 12.0

@export_subgroup("Combat Options")
@export_enum ("Melee", "Ranged", "Melee + Ranged") var combat_type: int

var isMoving := true
var isJumping := true
var y_velocity: float

var move_direction
var forward
var right
var timer = 5.0
var isRight = false
var is_target = false

@onready var target_manager = $"../../../Player/TargetManager"
@onready var target_sprite = $"../../../Player/TargetManager/TargetSprite"

func _ready() -> void:
	$Label3D.text = str(health)
	$CollisionShape3D.disabled = !can_interact

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dummy_type == 1:
		if movement_type == 0 or movement_type == 3:
			if timer > 0.0:
				if isRight == true:
					position.x = position.x - move_speed * delta
				else:
					position.x = position.x + move_speed * delta
				timer -= 0.1
			elif timer <= 0:
				if isRight == true:
					isRight = false
				else:
					isRight = true
				timer = 5.0


func _on_child_entered_tree(node: Node) -> void:
	if node == target_sprite:
		is_target = true

func _on_child_exiting_tree(node: Node) -> void:
	if node == target_sprite:
		is_target = false

func damage_calculate(enemyATK: int, skill_potency: int, true_damage: bool, playerDEF: int) -> int:
	var weaponVAR
	if true_damage == true:
		weaponVAR = 1
		playerDEF = 0
	else:
		weaponVAR = snappedf(randf_range(0.95,1.0), 0.01)
		
	var modifiers = (skill_potency / 100)
	
	return (enemyATK * weaponVAR - playerDEF) * modifiers * 0.2
		
func damage(damage_number: int):
	if can_interact:
		health -= damage_number
		$Label3D.text = str(health)
	else:
		return
	if health <= 0:
		if is_target == true:
			$TargetSprite.reparent(target_manager)
		queue_free()
