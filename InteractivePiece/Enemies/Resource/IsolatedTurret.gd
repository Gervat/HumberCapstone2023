extends 'res://InteractivePiece/_Master/Resource/InteractivePiece.gd'
###===================================================================
### TURRET AI
### Notes:
###			For some reason, Godot's if statements (in terms of the
###			== operator) don't work like it's supposed to, so there
###			are sketchy, back alley work arounds present. It's
###			basically nazi occupied Italy with all this spaghetti in
###			here...
###===================================================================

#STATE MACHINE
enum{IDLE, ALERTED, FIRING, SEARCHING, LOST_SIGHT}
var currentState:int = IDLE setget updateState
#-------
export(float, 64, 270) var FieldOfViewAngle = 180.0
export(bool) var ScootAndShoot = false
export(bool) var ShowData = false


const StallTime = 3.0 #Time before it switches to laser firing

var enemy = null #Reference to enemy in vision
var lastKnownPos = Vector2.ZERO
var lookAngle:float = 1.0
var d = 0.1

var enemyVisible:bool = false
var turnDirection:bool = false #True = Right, False = Left

onready var raycast = $RayCast2D #Vision casting
onready var head = $Head #Moveable object, body stays rested
onready var Timers = {Idle=$Idle, Stall=$Stall}
onready var lasers = $Head/Laser
onready var dbg = $DebugInfo
###===================================================================
###-------SYSTEM
###===================================================================
func _ready() -> void:
	FieldOfViewAngle = deg2rad(FieldOfViewAngle / 2)
	State = Glob.OCCUPIED
	currentState = SEARCHING
	enemyVisible = false
	enemy = null

	dbg.active = ShowData
	dbg.createOverlay("Name")
	dbg.printv("Name", name)
	dbg.createOverlay("State")
	dbg.createOverlay("Glob Rot")
	dbg.createOverlay("Enemy")
	dbg.createOverlay("FoV")
	dbg.createOverlay("Visible")
	dbg.createOverlay("Look Angle")
	dbg.createOverlay("Status")
	dbg.createOverlay("Idle")
	dbg.createOverlay("Stall")

func _physics_process(delta: float) -> void:
	d = delta
	##DEBUG STUFF
	if Glob.Cheater: debug()
	sitrep()
	act()

###===================================================================
###-------USER
###===================================================================
#-------GARNISHES -> Readability
func act():
	match currentState:
		SEARCHING:
			search()
		ALERTED:
			if enemyVisible: head.global_rotation = move_toward(head.global_rotation, lookAngle, d)
		LOST_SIGHT:
			if inspect(): idle(1.0)
		FIRING:
			if ScootAndShoot: head.global_rotation = move_toward(head.global_rotation, lookAngle, d / TAU)
			if !lasers.initiated: lasers.startBlasting()
		IDLE:
			pass
func debug():
	dbg.printv("Enemy", enemy)
	dbg.printv("Glob Rot", str(head.global_rotation) + " rad " + str(head.global_rotation_degrees) + " degrees.")
	dbg.printv("FoV", str(FieldOfViewAngle) + " rad " + str(rad2deg(FieldOfViewAngle)) + " degrees.")
	dbg.printv("Visible", enemyVisible)
	dbg.printv("Look Angle", lookAngle)
	dbg.printv("Idle", Timers.Idle.time_left)
	dbg.printv("Stall", Timers.Stall.time_left)

func sitrep():
	#Check Visibility
	if enemy != null:
		raycast.look_at(enemy.global_position)
		enemyVisible = raycast.get_collider().has_meta("ball") and raycast.is_colliding()
	#Update the LookAt positions
	lookAngle = clamp(lastKnownPos.angle_to_point(head.global_position) if !enemy else enemy.global_position.angle_to_point(head.global_position), -FieldOfViewAngle, FieldOfViewAngle)

func turnHead() -> bool:
	if head.global_rotation < FieldOfViewAngle and turnDirection: #Move head right if true
		head.rotate(d / TAU)
		return false
	elif head.global_rotation > -FieldOfViewAngle and !turnDirection: #Move head Left if true
		head.rotate(-d / TAU)
		return false

	return true

#-------MAIN MEAT -> Functional
func inspect() -> bool:
	head.global_rotation = move_toward(head.global_rotation, lookAngle, d / PI)
	if enemyVisible:
		updateState(ALERTED)
		return true
	if move_toward(head.global_rotation, lookAngle, d / PI) == lookAngle: return true
	return false

func search():
	if !enemyVisible: if turnHead(): idle(1.0)
	if enemyVisible: updateState(ALERTED)

func idle(time:float):
	dbg.printv("Status", "Starting Idle")
	Timers.Idle.start(time)
	updateState(IDLE)



###===================================================================
#-------SIGNALS
###===================================================================
func updateDetection(body, enemyIsNearby): #body_entered/_exited
	if enemyIsNearby and body.has_signal("ball"):
		dbg.printv("Status", "Ball is nearby")
		enemy = body
	if !enemyIsNearby:
		enemy = null
		dbg.printv("Status", "Ball left view")
		enemyVisible = false
		lastKnownPos = body.global_position
	if currentState == ALERTED and !enemyIsNearby:
		updateState(LOST_SIGHT)

func _on_StallTime_timeout() -> void:
	if enemy != null and currentState == ALERTED and enemyVisible: #check if we're still valid
		dbg.printv("Status", "KA...")
		updateState(FIRING)
func _on_Idle_timeout() -> void:
	turnDirection = !turnDirection
	if !enemyVisible:updateState(SEARCHING)
	if enemyVisible:updateState(ALERTED)

###===================================================================
#-------SETGETS
###===================================================================
func updateState(v): #Put starting actions here (non-recurring)
	currentState = v
	if currentState == IDLE: dbg.printv("State", "IDLE")
	if currentState == ALERTED:
		$Alert.play()
		Timers.Stall.start(StallTime)
		dbg.printv("State", "ALERTED")
	if currentState == FIRING:
		dbg.printv("Status", "IMA FIRIN' MAH LAZAH")
		dbg.printv("State", "FIRING")
	if currentState == SEARCHING: dbg.printv("State", "SEARCHING")
	if currentState == LOST_SIGHT: dbg.printv("State", "LOST_SIGHT")


func _on_Laser_FiringComplete() -> void:
	idle(3.0)
func _on_EnemyHit() -> void:
	pass # Replace with function body.

