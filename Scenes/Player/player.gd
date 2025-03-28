extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	SLIDE,
	MOVE,
	BLOCK,
	JUMP,
	HURT,
	FALL,
	DEATH
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var attackLabel = $"../Labels/Attack"

var health = 100
var gold = 0
var state = MOVE
var run_speed = 1
var combo = false
var attack_cooldown = false

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			pass
		ATTACK:
			attackState()
		ATTACK2:
			attack2State()
		ATTACK3:
			attack3State()
		SLIDE:
			slideState()
		MOVE:
			moveState()
		BLOCK:
			blockState()
		JUMP:
			pass
		HURT:
			pass
		FALL:
			pass
		DEATH:
			pass
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play('Jump')

	if velocity.y > 0:
		animPlayer.play('Fall')

	if health <= 0:
		health = 0
		animPlayer.play("Death")
		await animPlayer.animation_finished 
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

	move_and_slide()


func moveState():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("Walk")
			else: 
				animPlayer.play("Run")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
		
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
		
	if Input.is_action_pressed("run"):
		run_speed = 2
	else:
		run_speed = 1
		
	if Input.is_action_just_pressed("block"):
		if velocity.x == 0:
			state = BLOCK
		else:
			state = SLIDE
			
	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		state = ATTACK


func blockState():
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE


func slideState():
	animPlayer.play("Slide")
	await animPlayer.animation_finished 
	state = MOVE


func attackState():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2

	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished 
	makeAttackCooldown()
	state = MOVE


func attack2State():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3

	animPlayer.play("Attack2")
	await animPlayer.animation_finished 
	state = MOVE


func attack3State():
	animPlayer.play("Attack3")
	await animPlayer.animation_finished 
	state = MOVE


func makeCombo():
	combo = true;
	await animPlayer.animation_finished 
	combo = false;


func makeAttackCooldown():
	attack_cooldown = true
	var cooldown_time = 5.0

	while cooldown_time > 0:
		attackLabel.text = "Cooldown: " + str(round(cooldown_time)) + "s"
		await get_tree().create_timer(1).timeout
		cooldown_time -= 1

	attack_cooldown = false
	attackLabel.text = "Ready to attack"

func deathState():
	animPlayer.play("Death")
	await animPlayer.animation_finished 
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
	#await get_tree().process_frame
