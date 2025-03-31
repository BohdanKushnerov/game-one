extends CharacterBody2D


@onready var animMashroom = $AnimationPlayer

const SPEED = 100.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	animMashroom.play("Attack")
