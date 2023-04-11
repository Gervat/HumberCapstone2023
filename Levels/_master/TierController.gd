extends Node
#TierPhases
enum {OFF=0, CONQUEST, SERVO, COMPLETE}
#Descriptors
var sleep = false setget updateSleepState
var State = Glob.OFF setget makeAll
var phase = OFF
var active = false setget activate
export(int) var tierNum = 1
onready var EMan = get_node(Glob.EMan)
export(NodePath) var TierLock

signal Phased(cPhase)

#Child Refs - For speedy calls/iteration
onready var LevelSolids = $Solids.get_children()
onready var InteractivePieces = $IntPieces.get_children()
# warning-ignore:unused_class_variable
onready var Sets = $Sets.get_children()
onready var CQPanel = $ConquestPanel
#onready var TierExitDoor = $DefaultPieces/TierExitDoor
###===================================================================
###-------SYSTEM
###===================================================================
func _ready() -> void:
	$AreaTriggers/TierTrigger.connect('body_entered', EMan, 'tierTrigger', [tierNum, true])
	$AreaTriggers/TierTrigger.connect('body_entered', self, 'setSleep', [false])
	$AreaTriggers/TierTrigger.connect('body_exited', EMan, 'tierTrigger', [tierNum, false])
	$AreaTriggers/TierTrigger.connect('body_exited', self, 'setSleep', [true])
	TierLock = get_node(TierLock)
	State = Glob.OCCUPIED
	if EMan:
		if EMan.connect('LevelEvent', CQPanel, 'event') != OK: Glob.Log('ConnectEvent Fail: ConquestPanel')
	for i in InteractivePieces.size():
		if InteractivePieces[i].is_in_group('Scoring'):
			InteractivePieces[i].connectScoringSignal(EMan, "addScore")
		if InteractivePieces[i].trackHits:
			InteractivePieces[i].connectHitSignal(EMan, "pieceHit")
	for i in Sets.size():
		if Sets[i].connect('SetTrigger', EMan, 'SetTrigger') != OK: Glob.Log('ConnectSet Fail: %s' % name)
	if $AreaTriggers/LaunchTube.connect('body_exited', self, 'ballLaunched') != OK: Glob.Log('ConnectLaunched Fail: ' + name)
	call_deferred('activate', false)
###===================================================================
###-------MANAGEMENT DUTIES
###===================================================================
func resetConquest():
	CQPanel.reset()
func activate(v):
	active = v
	CQPanel.decaying = v
###===================================================================
###-------SIGNAL HANDLING
###===================================================================

func setSleep(_body: Node, state: bool) -> void:
	updateSleepState(state)

func changePhase(cPhase:int):
	match cPhase:
		OFF:
			activate(false)
			phase = OFF
			makeAll(Glob.OFF)
		CONQUEST:
			phase = CONQUEST
			makeAll(Glob.OCCUPIED)
		SERVO:
			phase = SERVO
			if !TierLock.Doors.empty():
				for i in TierLock.Doors.size():
					TierLock.Doors[i].locked = false
			makeAll(Glob.PLAYER)
			CQPanel.conquered = true
			CQPanel.setOwner(true)
		COMPLETE:
			phase = COMPLETE
			$'../HUD'.updateCompanion($'../../CompMan'.TierGet(), true)
			CQPanel.setAccess(true)
			pass
	emit_signal("Phased", cPhase)

###===================================================================
###-------SETGETS
###===================================================================
func makeAll(v=Glob.OFF):
	#if is_inside_tree():
		State = v
		CQPanel.changeState(State)
		for i in InteractivePieces.size():
			if InteractivePieces[i].State: InteractivePieces[i].State = State

		yield(InteractivePieces[0].anim, 'animation_started')
		for i in LevelSolids.size():
			if LevelSolids[i]: LevelSolids[i].State = State

func updateSleepState(v):
	sleep = v
	for i in LevelSolids.size() - 1:
		LevelSolids[i].sleeping = sleep
	for i in InteractivePieces.size() - 1:
		InteractivePieces[i].sleeping = sleep

func event():
	if EMan.TYPE == 'Area' and EMan.NAME == 'Death':
		if EMan.OTHER == 'Sink':
			$IntPieces/Launcher.autoLaunch = true
		if EMan.OTHER == 'Conquest':
			$IntPieces/Launcher.autoLaunch = false
			activate(false)
	if EMan.TYPE == 'SetUnlocked':
		if EMan.OBJECT.name == TierLock.name and phase == SERVO:
			changePhase(COMPLETE)
func ballLaunched(_body):
	if $'..'.currentTier == tierNum: activate(true)
