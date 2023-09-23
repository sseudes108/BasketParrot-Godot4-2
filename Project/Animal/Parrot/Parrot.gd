extends RigidBody2D

var dead: bool = false

var _dragging: bool = false
var _released: bool = false
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_position: Vector2 = Vector2.ZERO
var _last_drag_amount: float = 0.0
var _fired_time: float = 0.0

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

func Die() -> void:
	ExitedScreen()

func ExitedScreen():
	if dead == true:
		return
	dead = true
	SignalManager.ParrotDead.emit()
	pass


func MouseInput(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("Drag"):
		print(event)
