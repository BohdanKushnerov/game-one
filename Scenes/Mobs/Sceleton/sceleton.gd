extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var chase: bool = false
@onready var anim = $AnimatedSprite2D
var alive: bool = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = $"../../Player"
	var direction = (player.position - self.position).normalized()
	
	if alive == true:
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play('Walk')
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play('Idle')
			
		if direction.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false

	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		body.velocity.y -= 200
		death()


func _on_damage_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		if alive == true:
			body.health -= 40
		death()
		
		
func death():
	alive = false
	anim.play('Death')
	await anim.animation_finished
	queue_free()
