extends Node2D
#Phases
enum {OFF=0, CONQUEST, SERVO, COMPLETE}

export var objectiveBased:bool = false
export var parasitic:bool = false
export var DecaySpeed:float = 1

export var HP:float = 300
export var StartHP:float = 150

var progress:float
var conquered:bool = false setget setOwner
var tierOpen:bool = false setget setAccess
var State:int = 8 setget changeState
var gameLost:bool = false
var decaying:bool = true

signal tierConquered
signal tierLost

onready var Bar = $PlayerConquestBar
onready var tween = $Tween
onready var anim = $AnimationPlayer
onready var flashAnim = anim.get_animation('FlashNewState')
onready var EMan = get_node(Glob.EMan)

#=======SYSTEM========================================================
func _ready() -> void:
	$ParasiteBar.visible = parasitic
	$DecayTimer.start(1.0)
	#STATUS (game phase 1 true)
	#SERVO ACCESS (game phase 2 false)
	setOwner(false)
	setAccess(false)
	Bar.max_value = HP
	Bar.value = StartHP
	if Perks.Perks['GottaGo']['active']:
		DecaySpeed = DecaySpeed * 2.0 + 1.0
	DecaySpeed = DecaySpeed - Glob.decayResist if Glob.decayResist <= DecaySpeed else 0.0
	if connect('tierConquered', get_parent(), 'changePhase') != OK: Glob.Log('ConnectConquer Fail: ' + name)
	if connect('tierLost', EMan, 'ballDeath') != OK: Glob.Log('ConnectLose Fail: ' + name)
	decaying = get_parent().active
	reset()

#=======USER==========================================================
func reset():
	updateBar(0, true)
func updateBar(val, reset:bool = false):
	progress += val
	if reset:
		gameLost = false
		progress = StartHP
		decaying = false
		setOwner(false)
		setAccess(false)
		Bar.value = StartHP
	if !conquered:
		tween.interpolate_property(Bar, "value", Bar.value, progress, 1)
		tween.start()
		#Win
		if progress >= Bar.max_value:
			decaying = false
			if Bar.value >= Bar.max_value:
				emit_signal("tierConquered", SERVO)
				setOwner(true)
		#Lose
		if Bar.value <= Bar.min_value:
			gameLost = true
			emit_signal('tierConquered', CONQUEST)
			emit_signal("tierLost", 'Conquest')
	else: progress = Bar.max_value if !gameLost else Bar.min_value
func changeState(v, withAnim:bool=true):
	State = v
	if withAnim:
		if is_inside_tree():
			flashAnim.track_set_key_value(flashAnim.find_track('Screen/TopBar:light_mask'), 0, State)
			flashAnim.track_set_key_value(flashAnim.find_track('Screen/BottomBar:light_mask'), 0, State)
		if $AnimationPlayer.is_inside_tree():
			anim.play('DimToNewState')
	if !withAnim:
		$Screen/TopBar.light_mask = State
		$Screen/BottomBar.light_mask = State
#=======SIGNALS=======================================================
func _on_DecayTimer_timeout() -> void:
	if !gameLost and decaying: updateBar(-DecaySpeed)
#=======SETGETS=======================================================
func setOwner(v):
	conquered = v
	$STATUS.text = 'FREE' if conquered else 'OCCUPIED'
	$STATUS.modulate = Color(0, 1, 1) if conquered else Color(1, 0.25098, 0)

func setAccess(v):
	tierOpen = v
	$ACCESS.text = 'GRANTED' if tierOpen else 'DENIED' #tierOpen = true
	$ACCESS.modulate = Color(0,1,0) if tierOpen else Color(0.603922, 0, 0) #tierOpen = false

func event():
	if EMan.TYPE == 'Piece' and EMan.NAME == 'Damage' and get_parent().tierNum == EMan.TIER:
		updateBar(EMan.OTHER * int(!objectiveBased))
	if EMan.TYPE == 'Area' and EMan.NAME == 'BallLaunched' and get_parent().tierNum == EMan.TIER:
		decaying = true

func objDamage(_oName, dmg):
	updateBar(dmg)

