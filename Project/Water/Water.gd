extends Area2D

@onready var splash = $Splash



func BodyEntered(_body):
	splash.pitch_scale = randf_range(0.5,1.1)
	splash.play()
