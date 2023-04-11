extends Node

var objectiveStage:int = 0

onready var EMan = get_node(Glob.EMan)
onready var exit = $UnlockExit
onready var mouth = $CircleTheMouth
onready var teeth =  $KnockOutTeeth
onready var teethObj = $TeethToKnock
onready var stomach = $UpsetStomach
onready var finishHim = $FinishHim

func _ready() -> void:
	objectiveStage = 0
	if $'../AreaTriggers/Jackpot/ChaosArea'.connect('body_entered', self, 'ChaosArea', [true]) != OK: Glob.Log("CHAOS AREA IN TIER1 FAILED TO CONNECT")
	if $'../AreaTriggers/Jackpot/ChaosArea'.connect('body_exited', self, 'ChaosArea', [false]) != OK: Glob.Log("CHAOS AREA IN TIER1 FAILED TO CONNECT")
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log("ConnectEMan Fail: " + name)

func checkStage():
	match objectiveStage:
		0: # Circle the Mouth
			mouth.active = true
		1: # Open the Mouth and enter
			mouth.active = false
			teeth.active = true
		2: # Knock out the teeth
			teeth.active = false
			teethObj.active = true
		3: # Upset the stomach
			stomach.active = true
		4: # Data Overload
			finishHim.active = true
		5: # Open Lock
			finishHim.active = false

	if $"..".phase == 2: exit.active = true


func ChaosArea(_body, entered):
	$'../LightSpeed'.wait_time = 0.1 if entered else 0.5

func event():
	if EMan.TYPE == 'Area' and EMan.NAME == 'BallLaunched' and EMan.TIER == $'../..'.currentTier:
		checkStage()

	if EMan.TYPE == 'Area' and EMan.NAME == 'Death':
		exit.active = false
		mouth.active = false
		teeth.active = false
		stomach.active = false

func objectiveEvent(oName, obj):
	if oName == teethObj.name or oName == stomach.name or oName == finishHim.name:
		$'../ConquestPanel'.objDamage(obj.name, obj.damage)
	objectiveStage += 1
	checkStage()

func phased(_cPhase:int):
	checkStage()
