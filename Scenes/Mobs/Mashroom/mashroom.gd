extends CharacterBody2D


enum MashroomState{
	IDLE,
	ATTACK,
	RUN,
	DEATH,
	TAKE_HIT,
	CHASE
}

var state: int = MashroomState.IDLE:
	set(value):
		state = value
		match state:
			MashroomState.IDLE:
				idle_state()
			MashroomState.ATTACK:
				attack_state()
			MashroomState.RUN:
				run_state()
			MashroomState.DEATH:
				death_state()
			MashroomState.TAKE_HIT:
				take_hit_state()
			MashroomState.CHASE:
				chase_state()

@onready var animPlayerMashroom = $AnimationPlayer
@onready var animSpriteMashroom = $AnimatedSprite2D
@onready var collisionMashroomShape = $AttackDirection/AttackRange/CollisionShape2D
@onready var attackDirectionMashroom = $AttackDirection

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var current_player_position: Vector2
var direction

func _ready() -> void:
	Signals.connect("player_position_update", Callable(self, '_on_player_position_update'))


func _on_player_position_update(player_position):
	current_player_position = player_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if state == MashroomState.CHASE:
		chase_state()

	move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	state = MashroomState.ATTACK


func idle_state():
	animPlayerMashroom.play("Idle")
	await get_tree().create_timer(1).timeout
	collisionMashroomShape.disabled = false
	state = MashroomState.CHASE


func attack_state():
	animPlayerMashroom.play("Attack")
	await  animPlayerMashroom.animation_finished
	collisionMashroomShape.disabled = true
	
	state = MashroomState.IDLE

func run_state():
	animPlayerMashroom.play("Run")


func death_state():
	animPlayerMashroom.play("Death")


func take_hit_state():
	animPlayerMashroom.play("Take Hit")


func chase_state():
	direction = (current_player_position - self.position).normalized()
	
	if direction.x < 0:
		animSpriteMashroom.flip_h = true
		attackDirectionMashroom.rotation_degrees = 180
	else:
		animSpriteMashroom.flip_h = false
		attackDirectionMashroom.rotation_degrees = 0
