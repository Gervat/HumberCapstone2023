extends Node

var prevNudgeForce:float = 0.0
var blocking:bool = false
var playerDamage:float = 1.0

signal skillEvent(type, sName)

#Duration based skills
enum{DAMAGE_BOOST=0, BLOCK=1, CLUSTER, SLOW, INF_NUDGE}

var SkillReady = [true, true, true, true]

onready var timers = [$Cooldown1, $Cooldown2, $Cooldown3, $Cooldown4]
onready var hotkeys = [$Duration1, $Duration2, $Duration3, $Duration4]
onready var durations = [$DamageBoostDur, $BlockDuration, $ClusterDuration, $SlowDuration, $ImpulseDuration]
onready var fondler = $'../BallHandler'

func _ready():
	prevNudgeForce = Glob.nudgeForce
	for i in timers.size():
		timers[i].connect('timeout', self, '_on_Cooldown_timeout', [i])
	for i in hotkeys.size():
		hotkeys[i].connect('timeout', self, '_on_hotkeyDuration', [i])
	for i in durations.size():
		durations[i].connect('timeout', self, '_on_Duration_timeout', [i])

#Input Handling
func _process(_delta: float) -> void:
	if Console.is_console_shown: return
	if Input.is_action_just_pressed("Skill1"):
		buttonPressed(0)
	if Input.is_action_just_pressed("Skill2"):
		buttonPressed(1)
	if Input.is_action_just_pressed("Skill3"):
		buttonPressed(2)
	if Input.is_action_just_pressed("Skill4"):
		buttonPressed(3)
func buttonPressed(i:int):
	if SkillReady[i]:
			SkillReady[i] = false
			handleSkill(i, Glob.EquippedSkills[i])
func _on_Cooldown_timeout(idx: int) -> void:
	SkillReady[idx] = true
	emit_signal('skillEvent', 'Cooled', 'idx', idx)

func handleSkill(idx, skill):
	Input.flush_buffered_events()
	timers[idx].start(Glob.EquippedSkills[idx].Cooldown)
	if Glob.EquippedSkills[idx].has('Duration'): hotkeys[idx].start(Glob.EquippedSkills[idx].Duration)
	match skill:
		Glob.damageBoost:
			playerDamage = Glob.damageBoost.Boost
			$DamageBoostDur.start(Glob.damageBoost.Duration)
			emit_signal('skillEvent', "Used", "damageBoost", idx)
		Glob.blockAttack:
			blocking = true
			$BlockDuration.start(Glob.blockAttack.Duration)
			emit_signal('skillEvent', "Used", "blockAttack", idx)
		Glob.fusterCluck:
			fondler.fusterCluck(true)
			$ClusterDuration.start(Glob.fusterCluck.Duration)
			emit_signal('skillEvent', "Used", "fusterCluck", idx)
		Glob.slowTime:
			Engine.time_scale = 0.5
			$SlowDuration.start(Glob.slowTime.Duration)
			emit_signal('skillEvent', "Used", "slow", idx)
		Glob.unlimitedNudge:
			infNudge(true)
			$ImpulseDuration.start(Glob.unlimitedNudge.Duration)
			emit_signal('skillEvent', "Used", "infNudge", idx)
		Glob.spawnLeft:
			fondler.moveBall("LeftFlipperSpawn", $"..".maxTier)
			emit_signal('skillEvent', "Used", "spawnL", idx)
		Glob.spawnRight:
			fondler.moveBall("RightFlipperSpawn", $"..".maxTier)
			emit_signal('skillEvent', "Used", "spawnR", idx)
		Glob.noSkill:
			print("No skill in slot ", idx+1)

func _on_Duration_timeout(skill: int) -> void:
	match skill:
		DAMAGE_BOOST:
			playerDamage = 1.0
		BLOCK:
			blocking = false
		CLUSTER:
			fondler.fusterCluck(false)
		SLOW:
			Engine.time_scale = 1.0
		INF_NUDGE:
			infNudge(false)

func infNudge(active) -> void:
 if active:
  prevNudgeForce = Glob.nudgeForce
  Glob.nudgeForce *= Glob.NudgeAmp
  Glob.nudgeCooldown = 0.2
 else:
  Glob.nudgeForce = prevNudgeForce
  Glob.nudgeCooldown = 1

func _on_hotkeyDuration(idx: int) -> void:
	emit_signal('skillEvent', 'Complete', 'hotkey', idx)
