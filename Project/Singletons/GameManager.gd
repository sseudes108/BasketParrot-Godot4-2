extends Node

const CUPGROUP: String = "Cup"

var mainScene: PackedScene = preload("res://Project/Main/Main.tscn")

func LoadMainScene() -> void:
	get_tree().change_scene_to_packed(mainScene)
