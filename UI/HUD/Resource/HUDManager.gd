extends CanvasLayer

var score:int = 0
var totalScore:int
var totalHits:int = 0
var cc:int = 1
var fastText:bool = false
var animType

onready var EMan = get_node(Glob.EMan)

signal ballsGone()
signal scoreAdd()

onready var scoreCard = $Score
onready var tween = $ScoreTween
onready var MxTimer = $ComboTimeout
onready var ccCard = $MX
onready var balls = $Balls
onready var companion = $Dialogue/CompText
onready var speed = $Speedometer/Speed
onready var Stween = $Speedometer/Tween

func _ready() -> void:
	tween.interpolate_property(self, "score", score, totalScore, 1)
	tween.start()
	cc = 1
	balls.text = "%02d" % 3
	playCompAnim("Neutral")


func _physics_process(delta: float) -> void:
	scoreCard.text = "%09d" % score
	ccCard.text = "%02d" % cc
	companion.percent_visible += delta / (PI/2) if !fastText else delta

	#could either tie speed label or ballspeed value to the updatespeedometer value
	#UpdateSpeedometer(speed.text)
	#UpdateSpeedometer(ballspeed)

#===============================================================================
### SPEEDOMETER CORNER
#===============================================================================

func UpdateSpeedometer(value):
	$Speedometer/Speed_Left.value = value / 33
	$Speedometer/Speed_Right.value = value / 33
	speed.text = str(int(value / 33)).pad_zeros(3)

#===============================================================================
### SCORING CORNER
#===============================================================================
#Runs once per EventMan signal in GameMan
func updateScore(value):
	var addCC:bool = false
	#Start Combo counter and check what combo we're at
	MxTimer.start(5.0)
	totalHits += 1
	addCC = (totalHits == 1 and cc <= 5) \
	or (totalHits == 2 and cc <= 10) or (totalHits == 3 and cc <= 15)\
	or (totalHits == 4 and cc <= 20) or (totalHits == 5 and cc <= 25)\
	or (totalHits == 6 and cc <= 30) or (totalHits == 7 and cc >  30)
	if addCC:
		totalHits = 0
		cc += 1
	#Calculate score to add
	totalScore += value * cc
	emit_signal('scoreAdd', value * cc)
	#fAnCy sCoRe aDdInG
	tween.interpolate_property(self, "score", score, totalScore, 0.314)
	tween.start()

func touchBalls(v):
	balls.text = "%02d" % v
	if v < 0: emit_signal('ballsGone')

func getScore() -> int:
	return score

func _on_ComboTimeout_timeout() -> void:
	totalHits = 0
	cc = 1

func updateCompanion(text:String="...", quickly:bool=false):
	fastText = quickly
	companion.text = text
	companion.percent_visible = 0

func playCompAnim(type:String):
	match type:
		"Idle":
			$Dialogue/Cortana/AnimationPlayer.play("Idle")
		"Danger":
			$Dialogue/Cortana/AnimationPlayer.play("Danger")
		"Checkmark":
			$Dialogue/Cortana/AnimationPlayer.play("Checkmark")
		"Neutral":
			$Dialogue/Cortana/AnimationPlayer.play("Neutral")

func setMusic(text):
	$'Audio Visualizer/SongName'.text = str(text)
