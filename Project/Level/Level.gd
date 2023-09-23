extends Node2D

@onready var debugLabel = $"Debug Label"

func _ready():
	SignalManager.UpdateDebugLabel.connect(UpdateDebugLabel)

func _process(delta):
	pass

func UpdateDebugLabel(text: String) -> void:
	debugLabel.text = text
