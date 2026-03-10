extends CharacterBody3D

@onready var player = Globals.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scale += Vector3(5,5,5) * delta
	velocity.x = 500 * delta
	move_and_slide()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		body.damage(10000)
