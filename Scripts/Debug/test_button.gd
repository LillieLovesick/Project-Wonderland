extends Node3D

@onready var player = $"../../Player"

@export_enum ("Damage","Heal") var button_type: String
@export var amount : int = 0
@export var button_desc : String

var player_inside = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label3D.text = button_desc

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside == true:
		print("pressed")
		match button_type:
			"Damage":
				player.damage(amount)
			"Heal":
				player.damage(-amount)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_inside = true
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_inside = false
