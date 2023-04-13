extends Node

var objectiveStage:int = 0
onready var EMan = get_node(Glob.EMan)
onready var exit = $"4Buttons"
onready var hit = $HitObjective

onready var button1 = $"../DefaultPieces/ButtonL"
onready var button2 = $"../DefaultPieces/ButtonL2"
onready var button3 = $"../DefaultPieces/ButtonR"
onready var button4 = $"../DefaultPieces/ButtonR2"

func _ready() -> void:
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log("ConnectEMan Fail: " + name)
	objectiveStage = 0

func checkStage():
	match objectiveStage:
		0:
			hit.active = true
			button1.currState = 0
			button2.currState = 0
			button3.currState = 0
			button4.currState = 0
		1:
			hit.active = false
		2:
			exit.active = false

func event():
	if EMan.TYPE == 'Area' and EMan.NAME == 'BallLaunched' and EMan.TIER == 1:
		checkStage()

	if EMan.TYPE == 'Area' and EMan.NAME == 'Death' and EMan.TIER == 1:
		hit.active = false
		exit.active = false

#every time phase changes, check the stage function
func phased(_cPhase:int):
	if $"..".phase == 2:
		hit.active = false
		exit.active = true
		button1.currState = 3
		button2.currState = 3
		button3.currState = 3
		button4.currState = 3
	checkStage()

#when the button exit objective completes, trigger this function to lock buttons so exit gate perm open
func buttonsobjectiveComplete(_name, _obj):
	objectiveStage += 1
	$"../DefaultPieces/ExitRampGateBolt".open = true
	button1.currState = 0
	button2.currState = 0
	button3.currState = 0
	button4.currState = 0
	checkStage()

# exit set complete, open the gate
func _on_TierExit_SetTrigger(type, _name, _tier):
	if type == "Complete":
		$"../DefaultPieces/ExitRampGateBolt".open = true

# hit objective complete, progress stage
func _on_HitObjective_objectiveComplete(_name, _obj):
	objectiveStage += 1
	checkStage()

