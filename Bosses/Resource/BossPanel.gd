extends Node2D

export(bool) var parasitic:bool = false

var State:int = Glob.ENEMY setget changeState # for not upsetting tier handling

var progress = 50.0
var DecaySpeed:float 						  # for not upsetting tier handling
var decaying:bool 	 						  # for not upsetting tier handling
var dead:bool = false
var gameLost:bool = false

export var HP:float = 300
export var StartHP:float = 150

signal Win
signal Lose

onready var EMan = get_node(Glob.EMan)
onready var Bar = $PlayerConquestBar
onready var anim = $AnimationPlayer
onready var tween = $Tween

func _ready() -> void:
	$ParasiteBar.visible = parasitic
	#STATUS (game phase 1 true)
	#SERVO ACCESS (game phase 2 false)
	setStatus(true)
	Bar.max_value = HP
	progress = StartHP
	Bar.value = StartHP
	if Perks.Perks['GottaGo']['active']:
		DecaySpeed = DecaySpeed * 2.0 + 1.0
	DecaySpeed = DecaySpeed - Glob.decayResist if Glob.decayResist <= DecaySpeed else 0.0
	if connect('Lose', EMan, 'ballDeath') != OK: Glob.Log('ConnectLose Fail: ' + name)
	if connect('Win', EMan, 'endGame') != OK: Glob.Log('ConnectLose Fail: ' + name)
	decaying = get_parent().active
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log('Connect LevelEvent: ' + name)


func setStatus(active):
	$STATUS.text = 'ACTIVE' if active else 'ERROR'
	$STATUS.modulate = Color(1, 0.25098, 0) if active else Color(0, 1, 1)

func reset():
	updateBar(0, true)

func updateBar(val, reset:bool = false):
	progress += val
	if reset:
		gameLost = false
		progress = StartHP
		decaying = false
		changeState(Glob.OCCUPIED)
		setStatus(true)
		Bar.value = StartHP
	if !dead:
			tween.interpolate_property(Bar, "value", Bar.value, progress, 1)
			tween.start()
			#Win
			if progress >= Bar.max_value:
				setStatus(false)
				decaying = false
				if Bar.value >= Bar.max_value:
					emit_signal("Win", true)
			#Lose
			if Bar.value <= Bar.min_value:
				gameLost = true
				emit_signal('Lose')
	else: progress = Bar.max_value if !gameLost else Bar.min_value

func changeState(v, withAnim:bool=true):
	State = v
	if withAnim:
		if $AnimationPlayer.is_inside_tree():
			anim.play('DimToNewState')
	if !withAnim:
		changeLights()

func changeLights():
	$Screen/TopBar.light_mask = State
	$Screen/BottomBar.light_mask = State

func event():
	if EMan.TYPE == 'Piece' and EMan.NAME == 'Damage' and get_parent().tierNum == EMan.TIER:
		updateBar(EMan.OTHER)
	if EMan.TYPE == 'Area' and EMan.NAME == 'BallLaunched' and get_parent().tierNum == EMan.TIER:
		decaying = true
