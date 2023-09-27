extends RigidBody2D

#Sounds
@onready var stretch = $Stretch
@onready var lunch = $Lunch
@onready var collision = $Collision

#Placement and Score
@onready var stop = $Stop
@onready var hit = $Hit

#Constants
const STRETCHMAX: Vector2 = Vector2(-60,0)
const STRETCHMIN: Vector2 = Vector2(0,60)
const IMPULSEFORCE: float  = 810.0
const FIREDELAY: float = 0.27
const STOPPED: float = 0.2

#drag
var dragging: bool = false
var released: bool = false
var start: Vector2 = Vector2.ZERO
var dragStart: Vector2 = Vector2.ZERO
var draggedVector: Vector2 = Vector2.ZERO
var lastDraggedPosition: Vector2 = Vector2.ZERO
var lastDragAmount: float = 0.0
var firedTime: float = 0.0
var lastCollisionCounter: int = 0

var dead: bool = false

func _ready():
	SetUpTargets()
	start = global_position

func _physics_process(delta):
	UpdateDebugLabel()
	#Release
	if released == true:
		firedTime += delta
		if firedTime > FIREDELAY:
			Collision()
#			CheckOnTarget()
	else:
		if dragging == false:
			return
		else:
			if Input.is_action_just_released("Drag") == true:
				Release()
			else:
				Drag()

# Logic

func SetUpTargets() -> void:
	var targetCup = get_tree().get_nodes_in_group(GameManager.CUPGROUP)
	ScoreManager.SetTargetCups(targetCup.size())

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
	lunch.pitch_scale = randf_range(0.7,1.1)
	lunch.play()
	ScoreManager.AttemptMade()

func GetImpulse() -> Vector2:
	return draggedVector * -1 * IMPULSEFORCE

func Collision() -> void:
	if(
		lastCollisionCounter == 0 and 
		get_contact_count() > 0
		and collision.playing == false
	):
#		collision.play()
		lastCollisionCounter = get_contact_count()
		stop.start()
		hit.start()
		released = false

func Stoped() -> bool:
	if  get_contact_count() >= 1:
		print("0")
		return true
	else:
		return false

func TimeToStop():
	CheckOnTarget()

func CheckOnTarget() -> void:
	if Stoped() == true:
		var contacts = get_colliding_bodies()
		if contacts[0].is_in_group(GameManager.CUPGROUP) == true:
			contacts[0].timer.start()
			#contacts[0].Vanish()
		else:
			pass

# Die And Replace Animal
func Hit():
	queue_free()

func Die() -> void:
	ExitedScreen()

func ExitedScreen():
	if dead == true:
		return
	dead = true
	SignalManager.ParrotDead.emit()
	pass

#Input
func MouseInput(viewport, event: InputEvent, shape_idx):
	if dragging == true or released == true:
		return
	
	if event.is_action_pressed("Drag"):
		Grab()

#Debug
func UpdateDebugLabel() -> void:
	#position
	var position = "Position: " + Pandora.VectorToStr(global_position)
	var contacts = " Contacts: %s" % lastCollisionCounter
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
		contacts +
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

func _on_body_entered(body):
	var contacts = get_colliding_bodies()
	if contacts[0].is_in_group(GameManager.CUPGROUP) == true:
		if collision. playing == false:
			collision.pitch_scale = randf_range(0.5,1.1)
			collision.play()
	else:
		pass
