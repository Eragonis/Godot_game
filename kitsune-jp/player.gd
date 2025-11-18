extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var is_transformed = false  # Flag für den transformierten Zustand
var is_transform_playing = false
var transform_timer: Timer # Der Timer für den transformierten Zustand

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

	# Timer initialisieren und mit der Funktion "on_transform_timeout" verbinden
	transform_timer = Timer.new()
	transform_timer.wait_time = 30.0  # Transformation dauert 30 Sekunden
	transform_timer.one_shot = true    # Timer nur einmal ausführen
	transform_timer.timeout.connect(self._on_transform_timeout)
	add_child(transform_timer)         # Timer zum aktuellen Node hinzufügen
	
	$AnimatedSprite2D.animation_finished.connect(_on_anim_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("Jump"):
		velocity.y -= 1   # normalerweise nach oben = negativ
		
	# Transformation aktivieren (Taste R)
	if Input.is_action_just_pressed("Transformation") and !is_transformed:
		$AnimatedSprite2D.animation = "Transformation"  # Transformation-Animation starten
		$AnimatedSprite2D.play()  # Animation abspielen
		is_transformed = true  # Setze den transformierten Zustand
		transform_timer.start()  # Timer starten
		return  
		
		# Wenn Transformation läuft, nichts überschreiben
		if is_transform_playing:
			return
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		
		
		if velocity.x !=0:
			$AnimatedSprite2D.animation = "Walk"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.y > 0
		
		if velocity.y !=0:
			$AnimatedSprite2D.animation = "Jump"
			$AnimatedSprite2D.flip_v = velocity.y > 0
		
	else:
		if is_transformed:
			$AnimatedSprite2D.animation = "Idle_T"  # Transformierte Idle-Animation
		else:
			$AnimatedSprite2D.animation = "Idle"  # Normale Idle-Animation
		$AnimatedSprite2D.play()

func _on_anim_finished():
	if $AnimatedSprite2D.animation == "Transformation":
		# Wenn Transformation fertig ist → Idle_T starten
		is_transform_playing = false
		$AnimatedSprite2D.animation = "Idle_T"
		$AnimatedSprite2D.play()
		
		
# Diese Funktion wird aufgerufen, wenn der Transformation-Timer abgelaufen ist
func _on_transform_timeout():
	is_transformed = false  # Setze den transformierten Zustand zurück
	$AnimatedSprite2D.animation = "Idle"  # Zurück zur normalen Idle-Animation
	$AnimatedSprite2D.play()


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
