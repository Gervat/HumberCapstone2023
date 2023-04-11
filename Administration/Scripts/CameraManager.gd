extends Position2D

enum{FOLLOW_BALL, GAME_OVER, GAME_WIN, CUTSCENES, INTRO}
export var state = FOLLOW_BALL
#this bool created to ensure camera doesnt follow/track ball during intro cutscene
var Cutscene:bool = false

func _ready() -> void:
	get_tree().paused = true

	if is_inside_tree():
		global_position.y = $Camera2D.limit_top

func _physics_process(delta: float) -> void:
	if Cutscene == true && $"../StoryCutscene".visible == false:
		if state == INTRO:
			global_position.y += 750 * delta
		if Input.is_action_just_pressed("ui_cancel"):
			$"../IntroCutscene/AnimationPlayer".play("RESET")
			EndIntro()

	if Cutscene == false:
		match state:
			FOLLOW_BALL: global_position.y = $'../GameManager/BallHandler'.getPlayerPos().y
			GAME_OVER: global_position.y += 50 * delta

func ZoomCam(boss:bool=false):
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(2,2), 3) if boss\
	else $Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(1.5,1.5), 3)
	$Tween.start()

func PlayIntro():
	#this function is called in StoryCutscene node in Board
	#pause the tree to play the intro animation
	Cutscene = true
	$"../IntroCutscene".visible = true
	$"../IntroCutscene/AnimationPlayer".play("IntroCutscene")
	EndIntro()

	#animation over, unpause tree, cutscene var is false to allow camera to follow/track ball

func EndIntro():
	state = FOLLOW_BALL
	yield($"../IntroCutscene/AnimationPlayer", 'animation_finished')
	$'../IntroCutscene/BoardName'.visible = false
	Cutscene = false
	$"..".Intro = false
	yield(get_tree().create_timer(0.3), 'timeout')
	get_tree().paused = false
