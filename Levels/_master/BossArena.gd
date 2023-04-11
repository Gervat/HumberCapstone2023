extends Node

export(int) var tierNum = 3

var State:int = Glob.ENEMY
var active:bool = false setget activate
var sleep:bool = false
var phase:int = 0

onready var EMan = get_node(Glob.EMan)
onready var CQPanel = $ConquestPanel

func _ready() -> void:
	$AreaTriggers/BossTrigger.connect('body_entered', EMan, 'tierTrigger', [tierNum, true])
	$AreaTriggers/BossTrigger.connect('body_entered', self, 'setSleep', [false])
	$AreaTriggers/BossTrigger.connect('body_exited', EMan, 'tierTrigger', [tierNum, false])
	$AreaTriggers/BossTrigger.connect('body_exited', self, 'setSleep', [true])


func makeAll(v=Glob.OFF):
#if is_inside_tree():
	State = v
	CQPanel.changeState(State)

func activate(v:bool):
	active = v
	#activate boss
	#activate decay
	#play stuff and animations
func resetConquest():
	CQPanel.reset()

func event():
	if EMan.TYPE == 'Area' and EMan.NAME == 'Death':
		if EMan.OTHER == 'Sink':
			$DefaultPieces/Launcher.autoLaunch = true
		if EMan.OTHER == 'Conquest':
			$DefaultPieces/Launcher.autoLaunch = false
			activate(false)
func setSleep(_body: Node, state: bool) -> void:
	updateSleepState(state)

func updateSleepState(v):
	$'../../CameraMan'.ZoomCam(true)
	sleep = v


