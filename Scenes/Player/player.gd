extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var playerAnim = $AnimatedSprite2D
var health = 100
var gold = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerAnim.play('Jump')

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			playerAnim.play("Run")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			playerAnim.play("Idle")
		
	if direction == -1:
		playerAnim.flip_h = true
	elif direction == 1:
		playerAnim.flip_h = false
		
	if velocity.y > 0:
		playerAnim.play('Fall')
		
	if health <= 0:
		deathPlayer()
	
	
	move_and_slide()


func deathPlayer():
	#playerAnim.play("Death")
	#await playerAnim.animation_finished  # Ждём окончания анимации
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
	queue_free()  # Удаляем персонажа после завершения анимации
