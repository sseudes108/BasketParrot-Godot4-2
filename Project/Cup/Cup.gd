extends StaticBody2D

@onready var animation = $Animation
@onready var vanish = $Vanish
@onready var timer = $Timer

func Vanish() -> void:
	animation.play("Vanish")
	vanish.play()

func Vanished() -> void:
	SignalManager.CupVanished.emit()
	SignalManager.ParrotDead.emit()
	queue_free()

func OnTimeout():
	print("1")
	Vanish()
