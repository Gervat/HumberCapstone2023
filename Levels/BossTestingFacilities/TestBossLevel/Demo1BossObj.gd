extends Node

var objectiveStage:int = 0

onready var EMan = get_node(Glob.EMan)
onready var boss = $"../Boss"
onready var playerhandler = $"../../BallHandler"
onready var bossAttack = $"../AreaTriggers/BossAttack"

onready var hit1 = $HitObjective1
onready var hit2 = $HitObjective2
onready var attackBoss1 = $AttackBoss1
onready var attackBoss2 = $AttackBoss2
onready var attack1Timer = $AttackBoss1/Timer
onready var attack2Timer = $AttackBoss2/Timer

onready var slingshots:Array = [$"../IntPieces/SlingshotTL", $"../IntPieces/SlingshotTL2", $"../IntPieces/SlingshotTR", $"../IntPieces/SlingshotTR2", $"../IntPieces/SlingshotR", $"../IntPieces/SlingshotR2", $"../IntPieces/SlingshotR3", $"../IntPieces/SlingshotL1", $"../IntPieces/SlingshotL2", $"../IntPieces/SlingshotL3"]

func _ready() -> void:
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log("ConnectEMan Fail: " + name)
	if boss.connect("angry", self, "angry") != OK: Glob.Log("Cannot connect Boss Angry")
	if boss.connect("weak", self, "weak") != OK: Glob.Log("Cannot connect Boss Angry")

	objectiveStage = 0

func checkStage():
	match objectiveStage:
		0: #nothing
			pass
		1: # boss angry, hit 2 bumpers to weaken
			hit1.active = true
			bossAttack.isActive(true)
		2: # boss weak, attack the boss!
			attack1Timer.start()
			bossAttack.isActive(false)
			hit1.active = false
			attackBoss1.active = true
		3: # boss angry, hit 2 bumpers to weaken
			attack1Timer.stop()
			attackBoss1.active = false
			bossAttack.isActive(true)
			hit2.active = true
		4: # boss weak, attack the boss!
			attack2Timer.start()
			bossAttack.isActive(false)
			hit2.active = false
			attackBoss2.active = true

func event():
	pass

func angry():
	objectiveStage += 1
	checkStage()

	var i = 0
	while i < slingshots.size():
		slingshots[i].Lethal = true
		i += 1

func weak():
	objectiveStage += 1
	checkStage()

	var i = 0
	while i < slingshots.size():
		slingshots[i].Lethal = true
		i += 1

	playerhandler.moveBall("AttackBossSpawn", $'..'.tierNum)




