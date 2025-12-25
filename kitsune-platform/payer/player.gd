extends CharacterBody2D

# Normale Bewegungseigenschaften
@export var speed: int = 160
@export var acceleration: int = 5
@export var jump_speed: int = -speed * 2
@export var gravity: int = speed * 5
@export var down_gravity_factor: float = 3

# Verbesserte Werte während Transformation
@export var trans_speed: int = 240
@export var trans_jump_speed: int = -trans_speed * 2

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_time: Timer = $JumpBufferTime
@onready var kitsune_timer: Timer = $KitsuneTime
@onready var transform_timer: Timer = $TransformTimer  # Timer für die 30 Sekunden Transformation

enum State {IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE

var is_transformed: bool = false  # Transformationsstatus

const BASE_SCALE_X := 0.25

func _ready() -> void:
	# Grundskalierung einmalig setzen
	animations.scale.x = BASE_SCALE_X
	animations.scale.y = 0.25
	
	# Transformations-Timer vorbereiten
	transform_timer.timeout.connect(_on_transform_timeout)

func _physics_process(delta: float) -> void:
	handle_input()
	update_movement(delta)
	update_states()
	update_animation()
	move_and_slide()

func handle_input() -> void:
	# Transformation starten (Taste: `transform` → R)
	if Input.is_action_just_pressed("transform") and not is_transformed:
		start_transformation()

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_time.start()

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		# Geschwindigkeit je nach Transformationsstatus (normal oder verbessert)
		var current_speed = trans_speed if is_transformed else speed
		velocity.x = move_toward(velocity.x, current_speed * direction, acceleration)

func update_movement(delta: float) -> void:
	# Transformierte oder normale Sprunghöhe
	if (is_on_floor() or kitsune_timer.time_left > 0) and jump_buffer_time.time_left > 0:
		velocity.y = trans_jump_speed if is_transformed else jump_speed
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
				current_state = State.IDLE
			if not is_on_floor() and velocity.y > 0:
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
	# Spiegelung der Animation Richtung prüfen
	if velocity.x != 0:
		animations.scale.x = BASE_SCALE_X * sign(velocity.x)

	# Wähle Animation basierend auf Transformationsstatus:
	match current_state:
		State.IDLE:
			animations.play("idle_T" if is_transformed else "idle")
		State.WALK:
			animations.play("walk_T" if is_transformed else "walk")
		State.JUMP:
			animations.play("jump_up_T" if is_transformed else "jump_up")
		State.DOWN:
			animations.play("jump_down_T" if is_transformed else "jump_down")

func start_transformation() -> void:
	# Transformation aktivieren
	is_transformed = true
	animations.play("transformation")  # Spiele Transformations-Animation ab

	# Zeitgesteuerte Rückkehr zur normalen Form
	transform_timer.start()

func _on_transform_timeout() -> void:
	# Transformationszeit abgelaufen
	is_transformed = false
