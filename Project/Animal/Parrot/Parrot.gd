extends RigidBody2D

#Release
@onready var stretch = $Stretch
@onready var lunch = $Lunch

const STRETCHMAX: Vector2 = Vector2(-60,0)
const STRETCHMIN: Vector2 = Vector2(0,60)
const IMPULSEFORCE: float  = 810.0

var dead: bool = false
#drag
var dragging: bool = false
var released: bool = false
var start: Vector2 = Vector2.ZERO
var dragStart: Vector2 = Vector2.ZERO
var draggedVector: Vector2 = Vector2.ZERO
var lastDraggedPosition: Vector2 = Vector2.ZERO
var lastDragAmount: float = 0.0
var firedTime: float = 0.0

func _ready():
	start = global_position

func _physics_process(delta):
	UpdateDebugLabel()
	
	if released == true:
		pass
	else:
		if dragging == false:
			return
		else:
			if Input.is_action_just_released("Drag") == true:
				Release()
			else:
				Drag()

func UpdateDebugLabel() -> void:
	#position
	var position = "Position: " + Pandora.VectorToStr(global_position)
	#drag
	var drag = "\nDragging: %s" % dragging
	var release = " Released: %s" % released
	var drgStart = "\nDrag Start: " + Pandora.VectorToStr(dragStart)
	var drgVector = " Drag Vector: " + Pandora.VectorToStr(draggedVector)
	var lstDrgPos = "\nLast Dragged Position: " + Pandora.VectorToStr(lastDraggedPosition)
	var lstDrgAmt = " Last Drag Amount: %.1f " % lastDragAmount
	var fireTime = "\nFired Time: %.1f " % firedTime
	#velocity
	var angular = "\nVel. Angular: %.1f /" % angular_velocity
	var linear = " Linear: " + Pandora.VectorToStr(linear_velocity)
	
	SignalManager.UpdateDebugLabel.emit(
		position + 
		drag +
		release +
		drgStart +
		drgVector +
		lstDrgPos +
		lstDrgAmt +
		fireTime +
		angular + 
		linear
		)

func Grab() -> void:
	dragging = true
	released = false
	dragStart = get_global_mouse_position()
	lastDraggedPosition = dragStart

func Drag() -> void:
	var mousePosition = get_global_mouse_position()
	
	lastDragAmount = (lastDraggedPosition - mousePosition).length()
	lastDraggedPosition = mousePosition
	
	draggedVector = mousePosition - dragStart
	
	draggedVector.x = clampf(
		draggedVector.x,
		STRETCHMAX.x,
		STRETCHMIN.x
	)
	draggedVector.y = clampf(
		draggedVector.y,
		STRETCHMAX.y,
		STRETCHMIN.y,
	)
	
	if lastDragAmount > 0 and stretch.playing == false:
		if(draggedVector != Vector2(-60,60)):
			stretch.play()
	
	global_position = start + draggedVector

func Release():
	dragging = false
	released = true
	freeze = false
	apply_central_force(GetImpulse())
	#stretch.Stop()
	lunch.play()

func GetImpulse() -> Vector2:
	return draggedVector * -1 * IMPULSEFORCE

func Die() -> void:
	ExitedScreen()

func ExitedScreen():
	if dead == true:
		return
	dead = true
	SignalManager.ParrotDead.emit()
	pass

func MouseInput(viewport, event: InputEvent, shape_idx):
	if dragging == true or released == true:
		return
	
	if event.is_action_pressed("Drag"):
		Grab()
