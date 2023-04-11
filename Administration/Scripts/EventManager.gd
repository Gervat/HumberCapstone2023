extends Node


export(Dictionary) var ListenFor = {
	Skills=true,
	Hits=true,
	Score=true,
	BallLaunch=true,

}
export(int) var numOfTiers:int = 3
var ListenForTier:Array = []
var listenFors = {Damage=true, Sets=true, Doors=true }

var TYPE:String
var NAME:String
var OBJECT:Node
var TIER:int
var OTHER #Malleable and Dangerous

signal MetaEvent
signal LevelEvent

var FeedbackEffect = preload('res://Resources/Effects/FeedbackEffect.tscn')

func _ready() -> void:
	for i in numOfTiers:
		ListenForTier.append(listenFors)

func clear():
	TYPE = ''
	NAME = ''
	OBJECT = null
	TIER = 0
	OTHER = null

###=============================================================================
### LEVEL EVENTS
###=============================================================================
func skill(type:String, sName, hotkey):
	if !ListenFor["Skills"]: return
	clear()
	OTHER = hotkey
	match type:
		"Used":
			TYPE = 'SkillUsed'
			match sName:
				"damageBoost":
					NAME = "DamageBoost"
				"blockAttack":
					NAME = "Block"
				"fusterCluck":
					NAME = "Bomb"
				"slow":
					NAME = "Slow"
				"infNudge":
					NAME = "Nudge+"
				"spawnL":
					NAME ="SpawnL"
				"spawnR":
					NAME ="SpawnR"
		"Complete":
			TYPE = 'SkillComplete'
		"Cooled":
			TYPE = 'SkillCooled'
		_: print("Skill Event TYPE mismatch! ", type)
	emit_signal('LevelEvent')

func pieceHit(obj, tier:int):
	if !ListenFor['Hits']: return
	clear()
	TYPE = 'Piece'
	NAME = 'Hit'
	OBJECT = obj
	OTHER = obj.hits if obj.hits else null
	TIER = tier
	emit_signal('LevelEvent')

func addScore(val):
	if !ListenFor['Score']: return
	clear()
	TYPE = 'Piece'
	NAME = 'ScoreAdded'
	OTHER = val
	emit_signal('LevelEvent')

func addDamage(val):
	clear()
	TYPE = 'Piece'
	NAME = 'Damage'
	OTHER = val
	TIER = $'../GameManager'.currentTier
	emit_signal('LevelEvent')

func ballDeath(deathType:String):
	clear()
	TYPE = 'Area'
	NAME = 'Death'
	OTHER = deathType
	spawnFeedback(load('res://Resources/Effects/SFX/teleport.wav'))
	emit_signal('LevelEvent')

func spawnFeedback(sample=load('res://Resources/Effects/UHOH.mp3str'), withParticles=false):
	var feedback = FeedbackEffect.instance()
	feedback.initialPos = $'../GameManager/BallHandler/PlayerBall'.global_position
	feedback.emit = withParticles
	feedback.sound = sample
	self.add_child(feedback)

func _on_HUD_ballsGone() -> void:
	clear()
	TYPE = 'Other'
	NAME = 'GameLost'
	emit_signal('LevelEvent')

func tierTrigger(body: Node, tier, goingIn) -> void:
	clear()
	TYPE = 'Area'
	NAME = 'Entered' if goingIn else 'Exited'
	OBJECT = body
	TIER = tier
	emit_signal('LevelEvent')

func ballLaunched(body, tier:int) -> void:
	if !ListenFor['BallLaunch']: return
	clear()
	TYPE = 'Area'
	NAME = 'BallLaunched'
	TIER = tier
	OBJECT = body
	emit_signal('LevelEvent')

func SetTrigger(eName, obj, tier):
	if !ListenForTier[tier-1]['Sets']: return
	clear()
	TYPE = 'SetComplete' if eName == 'Complete' else 'SetUnlocked' if eName == 'Unlocked' else 'SetClosed'
	NAME = obj.name
	TIER = tier
	OBJECT = obj
	emit_signal('LevelEvent')

func objective(oName, object):
	TYPE = 'Objective'
	NAME = 'Complete'
	OTHER = oName
	OBJECT = object
	emit_signal('LevelEvent')

###=============================================================================
### META EVENTS
###=============================================================================
func endGame(win:bool) -> void:
	clear()
	TYPE = 'Game'
	NAME = 'Finished'
	OTHER = 'Win' if win else 'Lost'
	emit_signal('MetaEvent')

func menuEvent(menuName:String, opened:bool):
	clear()
	TYPE = 'Menu'
	NAME = 'Opened' if opened else 'Closed'
	OTHER = menuName
	emit_signal('MetaEvent')
