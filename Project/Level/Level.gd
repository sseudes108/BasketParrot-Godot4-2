extends Node2D

#Parrot
var parrot: PackedScene = preload("res://Project/Animal/Parrot/Parrot.tscn")
@onready var startPosition = $StartPosition

@onready var debugLabel = $"Debug Label"

func _ready():
	SignalManager.UpdateDebugLabel.connect(UpdateDebugLabel)
	SignalManager.ParrotDead.connect(ParrotDead)
	ParrotDead()

func _process(delta):
	if ( Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE)):
		GameManager.LoadMainScene()

func UpdateDebugLabel(text: String) -> void:
	debugLabel.text = text

func ParrotDead() -> void:
	var newParrot = parrot.instantiate()
	newParrot.global_position = startPosition.global_position
	add_child(newParrot)
