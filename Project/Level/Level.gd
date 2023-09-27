extends Node2D

#Parrot
var parrot: PackedScene = preload("res://Project/Animal/Parrot/Parrot.tscn")
@onready var startPosition = $StartPosition
@onready var debugLabel = $"Debug Label"

@onready var canvas_layer = $CanvasLayer

func _ready():
	SignalManager.UpdateDebugLabel.connect(UpdateDebugLabel)
	SignalManager.ParrotDead.connect(ParrotDead)
	SetUpTargets()
	ParrotDead()

func SetUpTargets() -> void:
	var targetCup = get_tree().get_nodes_in_group(GameManager.CUPGROUP)
	ScoreManager.SetTargetCups(targetCup.size())

func _process(_delta):
	if ( Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE)):
		GameManager.LoadMainScene()

func UpdateDebugLabel(text: String) -> void:
	debugLabel.text = text

func ParrotDead() -> void:
	if canvas_layer.levelCompleted.visible == false:
		var newParrot = parrot.instantiate()
		newParrot.global_position = startPosition.global_position
		add_child(newParrot)
