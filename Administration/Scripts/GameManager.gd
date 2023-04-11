extends Node
enum {OFF=0, CONQUEST, SERVO, COMPLETE}

onready var EMan = get_node(Glob.EMan)
onready var BallMan = $BallHandler
onready var BossArena = $BossArena
export(Array, NodePath) onready var Tier
onready var HUD = $HUD
onready var BallSaveTimer = $LevelUtilities/BallSaver
onready var Anim = $LevelUtilities/AnimationPlayer

signal EndGame(win)
var completedTiers = 0
var currentTier = 1 setget mTier
var maxTier = 1
var scoreMulti:float = 1.0
var balls:int = 3
var ballSaverActive:bool = false setget ballSaver


func _ready() -> void:
	for i in Tier.size():
		Tier[i] = get_node(Tier[i])
	balls = 3
	checkPerks()
	mTier(1)
	maxTier = 1
	ballSaver(false)
	HUD.touchBalls(balls)



func _process(_delta: float) -> void:
	if BallSaveTimer.time_left < 7.0 and ballSaverActive:
		if !Anim.current_animation == 'SaverBlink': Anim.play('SaverBlink')

func _on_LevelEvent() -> void:

	match EMan.TYPE:
		'Area':
			AreaEvent()
		'Other':
			OtherEvent()
		'Piece':
			PieceEvent()

func bustBall(subjugated, save:bool=false):
	print('Busting Balls', balls, ' left...')
	if subjugated:
		Tier[maxTier-1].activate(false)
		BallMan.moveBall('LauncherSpawn', maxTier)
		$'../CameraMan'.state = 0
	else:
		BallMan.moveBall('LauncherSpawn', maxTier)
	balls -= int(!save)
	balls = int(clamp(balls, 0, 99))
	if balls == 0:
		emit_signal('EndGame', false)

	HUD.touchBalls(balls)
func ballSaver(v): ## SETGET
	if BallSaveTimer.is_inside_tree():
		ballSaverActive = v
		if v:
			BallSaveTimer.start()
			Anim.play('SaverTrue')
			return
		Anim.play('SaverFalse')
		print("Ball saver ", v)
func mTier(v): ## SETGET
	currentTier = v
	maxTier = currentTier if currentTier > maxTier else maxTier
	prints("CurrentTier:", currentTier)
	prints("MaxTier:", maxTier)


func AreaEvent():
	match EMan.NAME:
		'BallLaunched':
			ballSaver(true)
			Tier[EMan.TIER-1].active = true
		'Entered':
			mTier(EMan.TIER)

		'Exited':
			if EMan.TIER == 3:
				#do boss stuff
				pass
			if Tier[EMan.TIER-1].phase == SERVO:
				Tier[EMan.TIER-1].changePhase(COMPLETE)
				Tier[EMan.TIER-1].active = true
				completedTiers += 1
		'Death':
			if EMan.OTHER == 'Sink':
				bustBall(false, ballSaverActive)
			elif EMan.OTHER == 'Conquest':
				Tier[maxTier-1].resetConquest()
				bustBall(true)
func OtherEvent():
	match EMan.NAME:
		'BossDefeated': emit_signal('EndGame', true)
func PieceEvent():
	match EMan.NAME:
		'ScoreAdded':
			$HUD.updateScore(EMan.OTHER * scoreMulti)
		'Hit':
			pass

func checkPerks():
	if Perks.Perks['BallsUP']['active']:
		balls += 2
	if Perks.Perks['AllIn']['active']:
		scoreMulti = 3.0
		balls = 0
	if Perks.Perks['Shotgun']['active']:
		scoreMulti = 0.5
		balls *= 2
	if Perks.Perks['BallSaverTimeUP']['active']:
		BallSaveTimer.wait_time += 10.0
	if Perks.Perks['GottaGo']['active']:
		BallSaveTimer.wait_time = 99999999.0

func _on_BallSaver_timeout() -> void:
	ballSaver(false)

func getActiveObjectives() -> Array:
	return Tier[currentTier-1].find_node("Objectives").get_children()
