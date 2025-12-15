extends Area2D  # Spieler bleibt ein Area2D

@export var speed: int = 400  # Bewegungsgeschwindigkeit
@export var jump_speed: int = -800  # Ausgangssprunggeschwindigkeit (negative Y-Richtung)
@export var custom_gravity: int = 1600  # Schwerkraft
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO  # Bewegungsgeschwindigkeit des Spielers
var is_transformed = false  # Transformationsstatus
var is_jumping = false  # Gibt an, ob der Spieler springt
var ground_position_y: float = 0  # Position der Plattformen, auf denen der Spieler sicher landen kann
var screen_size: Vector2  # Spielbereich begrenzen
var transform_timer: Timer  # Timer für Transformation

func _ready():
	screen_size = get_viewport_rect().size

	# Transformations-Timer initialisieren
	transform_timer = Timer.new()
	transform_timer.wait_time = 30.0  # Transformation dauert 30 Sekunden
	transform_timer.one_shot = true
	transform_timer.timeout.connect(_on_transform_timeout)
	add_child(transform_timer)

	animations.animation_finished.connect(_on_anim_finished)

func _process(delta: float):
	apply_gravity(delta)  # Schwerkraft anwenden
	handle_input(delta)  # Steuerung bearbeiten

	# Spielerbewegung anwenden
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)  # Spieler innerhalb des Bildschirms begrenzen

	# Kollision mit Plattformen überprüfen
	check_platform_collision()

	# Animation aktualisieren
	update_animation()

func handle_input(delta: float):
	var move_direction = 0

	# Bewegen nach links oder rechts
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	if Input.is_action_pressed("move_right"):
		move_direction += 1

	# Seitliche Geschwindigkeit einstellen
	velocity.x = move_direction * speed * (2 if is_transformed else 1)

	# Springen
	if Input.is_action_just_pressed("Jump") and not is_jumping:
		is_jumping = true
		velocity.y = jump_speed * (2 if is_transformed else 1)  # Verdoppelte Sprungkraft bei Transformation

	# Transformation
	if Input.is_action_just_pressed("Transformation") and not is_transformed:
		is_transformed = true
		transform_timer.start()
		animations.animation = "Transformation"
		animations.play()

func apply_gravity(delta: float):
	# Schwerkraft wirkt nur, wenn der Spieler springt oder nicht auf dem Boden ist
	if is_jumping:
		velocity.y += custom_gravity * delta

func check_platform_collision():
	# Alle Plattformen durchgehen
	for body in get_overlapping_bodies():
		if body.name.contains("Platform"):  # Wenn es sich um eine Plattform handelt
			velocity.y = 0  # Schwerkraft stoppen
			is_jumping = false  # Spieler springt nicht mehr
			position.y = body.position.y - 50  # Spieler genau über der Plattform platzieren

func update_animation():
	if is_jumping and velocity.y < 0:
		# Nach oben springen
		animations.animation = "Jump_T" if is_transformed else "Jump"
	elif is_jumping and velocity.y > 0:
		# Nach unten fallen
		animations.animation = "Fall_T" if is_transformed else "Fall"
	elif velocity.x != 0:
		# Seitliche Bewegung
		animations.animation = "Walk_T" if is_transformed else "Walk"
		animations.flip_h = velocity.x < 0  # Wenn nach links, dann umdrehen
	else:
		# Stillstand
		animations.animation = "Idle_T" if is_transformed else "Idle"

	animations.play()

func _on_transform_timeout():
	is_transformed = false  # Transformation endet

func _on_anim_finished():
	if animations.animation == "Transformation":
		animations.animation = "Idle_T" if is_transformed else "Idle"
		animations.play()
