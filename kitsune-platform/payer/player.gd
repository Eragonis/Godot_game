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

# Animation und Timer
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_time: Timer = $JumpBufferTime
@onready var kitsune_timer: Timer = $KitsuneTime
@onready var transform_timer: Timer = $TransformTimer  # Timer für die 30 Sekunden Transformation

enum State {IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE

var is_transformed: bool = false  # Transformationsstatus
var is_transforming: bool = false  # Läuft momentan die Transformationsanimation?

const BASE_SCALE_X := 0.25

func _ready() -> void:
	# Grundskalierung für das Sprite setzen
	animations.scale.x = BASE_SCALE_X
	animations.scale.y = 0.25
	
	# Timer-Timeout verbinden
	transform_timer.timeout.connect(_on_transform_timeout)

	# Animation-Ende-Signal verbinden
	animations.animation_finished.connect(_on_anim_finished)

func _physics_process(delta: float) -> void:
	# Eingaben und Animationen nur verarbeiten, wenn keine Transformationsanimation aktiv ist
	if not is_transforming:
		handle_input()
		update_movement(delta)
		update_states()
		update_animation()
	move_and_slide()

func handle_input() -> void:
	if Input.is_action_just_pressed("transform") and not is_transformed and not is_transforming:
		start_transformation()
	
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_time.start()

	# Bewegung steuern
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		var current_speed = trans_speed if is_transformed else speed
		velocity.x = move_toward(velocity.x, current_speed * direction, acceleration)

func update_movement(delta: float) -> void:
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
	# Transformationsanimation hat Vorrang
	if is_transforming:
		return

	# Animationsauswahl basierend auf Zustand und Transformationsstatus
	if velocity.x != 0:
		animations.scale.x = BASE_SCALE_X * sign(velocity.x)

	match current_state:
		State.IDLE:
			animations.animation = "Idle_T" if is_transformed else "Idle"
		State.WALK:
			animations.animation = "Walk_T" if is_transformed else "Walk"
		State.JUMP:
			animations.animation = "Jump_T" if is_transformed else "Jump"
		State.DOWN:
			animations.animation = "Fall_T" if is_transformed else "Fall"

	animations.play()

# Transformation starten
func start_transformation() -> void:
	is_transforming = true  # Blockiere Animationenwechsel während der Animation
	animations.animation = "Transformation"  # Setze Transformationsanimation
	animations.play()
	transform_timer.start()  # Starte Rückkehr-Timer
	print("Transformationsanimation gestartet.")  # Debugging-Log

# Am Ende der Transformationsanimation
func _on_anim_finished():
	if animations.animation == "Transformation":
		is_transforming = false  # Transformationsanimation abgeschlossen
		is_transformed = true  # Wechsel zum Transformationsmodus
		animations.animation = "Idle_T"  # Wechsel zu Transformations-Idle
		animations.play()
		print("Transformationsanimation abgeschlossen.")  # Debugging-Log

# Rückkehr zum normalen Zustand
func _on_transform_timeout() -> void:
	is_transformed = false  # Rückkehr zur normalen Form
	print("Transformation beendet.")  # Debugging-Log
