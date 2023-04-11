extends RigidBody2D

export var State = Glob.OCCUPIED setget changeState
export(int) var BaseScoring = 1
# warning-ignore:unused_class_variable
export(bool) var Lethal = false
var ScoreVal:int
export(bool) var trackHits = false
# warning-ignore:unused_class_variable
var hits:int = 0
# warning-ignore:unused_signal
signal addScore(val)
# warning-ignore:unused_signal
signal Hit(obj, tier)
# warning-ignore:unused_signal
signal Damage(val)

var FeedbackEffect = preload('res://Resources/Effects/FeedbackEffect.tscn')
onready var anim = $AnimationPlayer

func parent_ready():
	ScoreVal = BaseScoring
	State = Glob.OCCUPIED
	changeLights()

func spawnFeedback(sample=load('res://Resources/Effects/UHOH.mp3str'), withParticles=false):
	var feedback = FeedbackEffect.instance()
	feedback.initialPos = global_position
	feedback.emit = withParticles
	feedback.sound = sample
	self.add_child(feedback)
func changeLights():
		$Sprite/Design.light_mask = State
		$Sprite/Outline.light_mask = State

###===================================================================
###-------SETGETS
###===================================================================
func changeState(v, withAnim:bool=true):
	State = v
	if withAnim and is_inside_tree():
		if has_meta('active'):
			if get_meta('active'):
				set_meta('boardState', State)
				State = 1024

		anim.play('DimToNewState')# <-----------First

	if !withAnim:
		changeLights()

func connectHitSignal(to, at):
	if !is_connected("Hit", to, at):
		if trackHits:
			if connect("Hit", to, at) != OK: print('ConnectHit fail: ', name)
func connectScoringSignal(to, at):
	if !is_connected("addScore", to, at):
		if connect("addScore", to, at) != OK: print('ConnectScore fail: ', name)
