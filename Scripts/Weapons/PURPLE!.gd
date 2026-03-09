extends CharacterBody3D

@onready var player = Globals.Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scale += Vector3(0.1,0.1,0.1) * delta
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	body.damage(10000)
