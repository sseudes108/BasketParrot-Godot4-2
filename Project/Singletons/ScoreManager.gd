extends Node

const DEFAULTSCORE: int = 999

var levelScores: Dictionary = {}
var levelSelected: int = 0
var attempts: int = 0
var cupsHit: int = 0
var targetCups: int = 0

func _ready():
	SignalManager.CupVanished.connect(CupVanished)


func _process(delta):
	pass

func CheckAdd(level: int) -> void:
	if levelScores.has(level) == false:
		levelScores[level] = DEFAULTSCORE

func LevelSelected(level: int) -> void:
	CheckAdd(level)
	levelSelected = level
	attempts = 0
	cupsHit = 0
	print("Level Selected:%s Level Score:%s" % [
		levelSelected, levelScores
	])

func BestForLevel(level: int) -> int:
	CheckAdd(level)
	return levelScores[level]

func GetAttempts() -> int:
	return attempts

func GetLevelSelected() -> int:
	return levelSelected

func SetTargetCups(cups: int) -> void:
	targetCups = cups
	print("Set Target Cups: ", targetCups)


func CupVanished() -> void:
	cupsHit += 1 
