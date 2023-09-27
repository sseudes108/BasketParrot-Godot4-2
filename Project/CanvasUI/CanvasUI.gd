extends CanvasLayer

@onready var level = $"MarginContainer/Level Info/level"
@onready var attempts = $"MarginContainer/Level Info/Attempts"
@onready var levelCompleted = $"MarginContainer/Level Completed"
@onready var music = $Music

func _ready():
	level.text = "level: %s" % ScoreManager.GetLevelSelected()
	AttemptMade()
	SignalManager.AttemptMade.connect(AttemptMade)
	SignalManager.GameOver.connect(GameOver)

func _process(_delta):
	if levelCompleted.visible == true and Input.is_key_pressed(KEY_SPACE):
		GameManager.LoadMainScene()

func AttemptMade() -> void:
	attempts.text = "Attempts: %s" % ScoreManager.GetAttempts()

func GameOver() -> void:
	levelCompleted.show()
	music.play()
