extends TextureButton

const HOVERSCALE: Vector2 = Vector2(1.2,1.2)
const DEFAULTSCALE: Vector2 = Vector2(1.0,1.0)

@export var levelNumber: int = 1
@export var levelToLoad: PackedScene
@onready var level = $MarginContainer/VBoxContainer/Level
@onready var score = $MarginContainer/VBoxContainer/Score


func _ready():
	level.text = str(levelNumber)

func HoverOn():
	scale = HOVERSCALE

func HoverOff():
	scale = DEFAULTSCALE

func Pressed():
	get_tree().change_scene_to_packed(levelToLoad)
