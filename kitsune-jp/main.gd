extends Node

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Game Over Logik
func game_over():
	$ScoreTimer.stop()  # Stoppe den Timer für den Score
	$MobTimer.stop()    # Stoppe den Timer für Mobs (falls vorhanden)
	print("Game Over!")  # Du kannst hier eine Game Over-Nachricht anzeigen

# Neues Spiel starten
func new_game():
	score = 0
	$Player.start($StartPosition.position)  # Setze den Player auf die Startposition
	$StartTimer.start()  # Starte den Start-Timer

	# Verbinde das hit-Signal vom Player mit der Game Over Funktion
	$Player.connect("hit", Callable(self, "_on_game_over"))

# Wenn der Score-Timer abläuft
func _on_score_timer_timeout():
	score += 1

# Wenn der Start-Timer abläuft
func _on_start_timer_timeout():
	$MobTimer.start()  # Startet den Mob-Timer
	$ScoreTimer.start()  # Startet den Score-Timer

# Wenn der Player getroffen wird, Game Over auslösen
func _on_game_over():
	game_over()  # Game Over Funktion aufrufen
	get_tree().paused = true  # Spiel pausieren
	# Optional: Zeige eine Game Over-Nachricht auf dem Bildschirm
