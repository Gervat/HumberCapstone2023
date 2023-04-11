extends CanvasLayer

signal objectiveComplete

export var activateOnLaunch:bool = false
export var goal:int = 5000
export var oneOff:bool = false
export var damage:float = 13.13
export var compText:String = 'getting a bunch of data'

var test:bool = false

var complete:bool = false setget completed
var active:bool = false setget activate
var totalScore:int = 0

onready var EMan = get_node(Glob.EMan)
onready var HUD = get_node(Glob.HUD)
onready var ProgLabel = $Progress
onready var ProgBar = $ProgressBar

func _ready():
	if connect('objectiveComplete', EMan, 'objective') != OK: Glob.Log("ConnectObjective Fail: " + name)
	if activateOnLaunch: if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log("ConnectEvent Fail: " + name)
	if HUD.connect('scoreAdd', self, 'scoreUpdate') != OK: Glob.Log("ConnectLEvent Fail: %s" % name)
	ProgBar.rotation_degrees = 0
	ProgBar.position = Vector2(1245, 21)
	$'../../../../CompMan'.objectives.append(self)
	completed(false)
	call_deferred('activate', false)

func _physics_process(_delta: float) -> void:
	self.visible = active
	if !active: return
	ProgLabel.text = '%d%%' % clamp(range_lerp(totalScore, 0, goal, 0, 100), 0, 100)
	ProgBar.scale.x = clamp(range_lerp(totalScore, 0, goal, -0.315, 0), -0.315, 0)

func completed(v):
	if !active: return
	complete = v
	if v:
		totalScore = 0
		activate(!oneOff and active)
		EMan.addDamage(100.0 if oneOff else damage)
		emit_signal('objectiveComplete', name, self)

func reset():
	activate(false)
	totalScore = 0

func activate(v):
	active = v
	visible = v
	$ColorRect.visible = v
	$Progress.visible = v
	$ProgressBar.visible = v
	$Polygon2D.visible = v
	$Label.visible = v

func event():
	if EMan.TYPE == 'Area' and EMan.NAME == "BallLaunched" and EMan.TIER == $'../..'.tierNum:
		if !activateOnLaunch: return
		activate(true)

func scoreUpdate(val):
	if !active: return
	test = !test
	totalScore += val
	completed((totalScore >= goal))
