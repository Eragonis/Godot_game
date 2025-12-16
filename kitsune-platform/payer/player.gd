extends CharacterBody2D

@export var speed: int = 160
@export var acceleration: int = 5
@export var jump_speed: int = -speed * 2
@export var gravity: int = speed * 5
@export var down_gravity_factor: float = 3


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_time: Timer = $JumpBufferTime
@onready var kitsune_timer: Timer = $KitsuneTime

enum State{IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE


const BASE_SCALE_X := 0.25

func _ready() -> void:
	# Grundskalierung einmalig setzen
	animations.scale.x = BASE_SCALE_X
	animations.scale.y = 0.25

func _physics_process(delta: float) -> void:
	handle_input()
	update_mocement(delta)
	update_states()
	update_animation()
	move_and_slide()

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_time.start()
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration)


func update_mocement(delta: float) -> void:
	if (is_on_floor() || kitsune_timer.time_left >0) && jump_buffer_time.time_left > 0:
		velocity.y = jump_speed
		current_state = State.JUMP
		jump_buffer_time.stop() 
		kitsune_timer.stop()
		
	if current_state == State.JUMP:
		velocity.y += gravity * delta 
	else:
		velocity.y += gravity * down_gravity_factor * delta


func update_states() -> void:
	match current_state:
		State.IDLE when velocity.x != 0:
			current_state = State.WALK
			
		State.WALK:
			if velocity.x == 0:
				current_state =State.IDLE
			if not is_on_floor() && velocity.y > 0:
				current_state = State.DOWN
				kitsune_timer.start()
				
		State.JUMP when velocity.y > 0:
			current_state = State.DOWN
			
		State.DOWN when is_on_floor():
			if velocity.x == 0:
				current_state = State.IDLE
			else:
				current_state = State.WALK

func update_animation() -> void:
	if velocity.x != 0:
		animations.scale.x = BASE_SCALE_X * sign(velocity.x)
		# also: -0.25 oder +0.25

	match current_state:
		State.IDLE: animations.play("idle")
		State.WALK: animations.play("walk")
		State.JUMP: animations.play("jump_up")
		State.DOWN: animations.play("jump_down")
