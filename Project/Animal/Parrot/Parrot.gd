extends RigidBody2D

func _ready():
	pass 

func _physics_process(delta):
	UpdateDebugLabel()

func UpdateDebugLabel() -> void:
	#position
	var position = "Position: " + Pandora.VectorToStr(global_position)
	#velocity
	var angular = "\nVel. Angular: %.1f /" % angular_velocity
	var linear = " Linear: " + Pandora.VectorToStr(linear_velocity)
	
	SignalManager.UpdateDebugLabel.emit(
		position + 
		angular + 
		linear
		)
