extends Node

onready var overload = $ScoreGets
onready var Anim = $LevelUtilities/AnimationPlayer
var phase:int

func _process(_delta: float) -> void:
	if $'../..'.BallSaveTimer.time_left < 7.0 and $'../..'.ballSaverActive:
		if !Anim.current_animation == 'SaverBlink': Anim.play('SaverBlink')

func _on_OverloadActivator_SetTrigger(type, _ename, _tier) -> void:
	if phase != 1: return
	if type == 'Unlocked':
		if !overload.active: overload.active = true

func _on_Tier2_Phased(cPhase) -> void:
	phase = cPhase
	if cPhase == 2:
		overload.active = false
