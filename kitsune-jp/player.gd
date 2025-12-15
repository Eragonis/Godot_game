extends Area2D

signal hit

@export var speed: int = 400
@export var jump_speed: int = -800
@export var custom_gravity: int = 1600
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

var velocity = Vector2.ZERO
var is_transformed = false
var is_jumping = false
var screen_size
var transform_timer: Timer

func _ready():
	screen_size = get_viewport_rect().size

	transform_timer = Timer.new()
	transform_timer.wait_time = 30.0
	transform_timer.one_shot = true
	transform_timer.timeout.connect(_on_transform_timeout)
	add_child(transform_timer)

	animations.animation_finished.connect(_on_anim_finished)

func _process(delta: float):
	apply_gravity(delta)
	handle_input(delta)
	
	# Bewegung anwenden
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Kollisionslogik: Bodenberührung
	if position.y >= screen_size.y - 100:  # Hier sicherstellen, dass "Boden" getroffen wird
		is_jumping = false
		velocity.y = 0  # Schwerkraft stoppen
		update_animation()  # Animation wechseln auf Idle/Landen

	update_animation()

func apply_gravity(delta: float):
	if is_jumping:
		velocity.y += custom_gravity * delta

func handle_input(delta: float):
	var velocity_x = 0

	# Horizontalbewegung (links/rechts)
	if Input.is_action_pressed("move_right"):
		velocity_x += 1
	if Input.is_action_pressed("move_left"):
		velocity_x -= 1

	# Transformation aktivieren
	if Input.is_action_just_pressed("Transformation") and !is_transformed:
		is_transformed = true
		animations.animation = "Transformation"
		animations.play()
		transform_timer.start()
		return

	# Geschwindigkeit an Transformationszustand anpassen
	var current_speed = speed * (2 if is_transformed else 1)
	velocity.x = velocity_x * current_speed

	# Springen nur vom Boden aus
	if Input.is_action_just_pressed("Jump") and not is_jumping:
		is_jumping = true
		velocity.y = jump_speed * (2 if is_transformed else 1)

func update_animation():
	# Kontrolliere, welche Animationen abgespielt werden sollen
	if velocity.y < 0:  # Nach oben springen
		animations.animation = "Jump_T" if is_transformed else "Jump"
	elif velocity.y > 0:  # Beim Fallen nach unten
		animations.animation = "Fall_T" if is_transformed else "Fall"
	elif velocity.x != 0:  # Bewegung links/rechts
		animations.animation = "Walk_T" if is_transformed else "Walk"
		animations.flip_h = velocity.x < 0
	else:  # Stillstand
		animations.animation = "Idle_T" if is_transformed else "Idle"
	animations.play()

func _on_transform_timeout():
	is_transformed = false

func _on_anim_finished():
	if animations.animation == "Transformation":
		animations.animation = "Idle_T" if is_transformed else "Idle"
		animations.play()

func _on_body_entered(body: Node2D):
	# Spieler wird bei Kollision versteckt
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
