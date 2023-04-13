extends Node

var objectiveStage:int = 0
onready var EMan = get_node(Glob.EMan)
onready var exit = $Exit
onready var unlock2f = $Unlock2f
onready var score = $Score
onready var hit = $HitObjective

func _ready():
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log("ConnectEMan Fail: " + name)
	objectiveStage = 0

func checkStage():

	match objectiveStage:
		0:
			$"../DefaultPieces/Button_1F_2".currState = 0
			$"../DefaultPieces/Button_1F_1".currState = 0
		1: # hit the button to unlock 2F ramps
			unlock2f.active = true
		2: # hit 2 buttons for conquest damage
			unlock2f.active = false
			hit.active = true
		3: # reach x score for conquest damage
			hit.active = false
			score.visible = true
			score.active = true
		4:
			unlock2f.active = false
			hit.active = false
			score.visible = false
			score.active = false
		5:
			pass

func event():
	#start tier 2 objectives when you enter tier 2
	if EMan.TYPE == 'Area' and EMan.NAME == 'Entered' and EMan.TIER == 2:
		objectiveStage += 1
		checkStage()

	if EMan.TYPE == 'Area' and EMan.NAME == 'BallLaunched' and EMan.TIER == 2:
		checkStage()

	if EMan.TYPE == 'Area' and EMan.NAME == 'Death' and EMan.TIER == 2:
		unlock2f.active = false
		hit.active = false
		score.active = false
		score.visible = false
		exit.active = false

#every time phase changes, check the stage function
func phased(_cPhase:int):
	if $"..".phase == 2:
		objectiveStage = 4
		exit.active = true
		$"../DefaultPieces/Button_1F_2".currState = 3
		$"../DefaultPieces/Button_1F_1".currState = 3
	checkStage()

# score objective
func objectiveComplete(_name, _obj):
	objectiveStage += 1
	checkStage()

# exit objective
func ExitObjectiveComplete(_name, _obj):
	# lock the buttons so exit ramp remains open
	$"../DefaultPieces/Button_1F_2".currState = 0
	$"../DefaultPieces/Button_1F_1".currState = 0

	#spawn in an object to block the 2 ramps to 2F
	$"../IntPieces/LeftGate".collision_mask = 1
	$"../IntPieces/LeftGate".modulate.a = 1
	$"../IntPieces/RightGate".collision_mask = 1
	$"../IntPieces/RightGate".modulate.a = 1
	#open exit gate
	$"../DefaultPieces/ExitGate".open = true

# exit set
func _on_TierExit_SetTrigger(type, _name, _tier):
	if type == "Complete":
		$"../DefaultPieces/ExitGate".open = true


func HitObjectiveComplete(_name, _obj):
	objectiveStage += 1
	checkStage()

# Unlock 2F Ramps Set
func _on_AmogusSet_SetTrigger(type, _name, _tier):
	if type == "Complete":
		$"../DefaultPieces/GateBolt".open = true
		$"../DefaultPieces/GateBolt2".open = true
		$"../DefaultPieces/Button_1F_3".currState = 0

# Unlock 2F Ramps Objective
func _on_Unlock2f_objectiveComplete(_name, _obj):
	objectiveStage += 1
	checkStage()


