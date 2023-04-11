extends Node2D

onready var HTP_Sprite = $HTPMain/Sprite
onready var HTP_Title = $HTPMain/SpriteName

var currentSet = 0
var HTP_IMG = [
	load("res://UI/HUD/Resource/IMG/HTP_Control.png"),
	#load("res://UI/HUD/Resource/IMG/HTP_HUD.PNG"),
	#load("res://UI/HUD/Resource/IMG/HTP_GAMEPLAY.PNG"), 
	]

func _ready():
	$HTPMain/LeftButton.visible = false
	$HTPMain/RightButton.visible = false
	HTP_Title.visible = true
	
	_HTPset(0)

func _HTPset(val):
	currentSet = wrapi(val, 0, 1)
	
	if currentSet == 0:
		HTP_Sprite.texture = HTP_IMG[0]
		HTP_Title.text = ('PLAYERCONTROLS')
	#if currentSet == 1:
		#HTP_Sprite.texture = HTP_IMG[1]
		#HTP_Title.text = ('PLAYERHUD')
	#if currentSet == 2:
		#HTP_Sprite.texture = HTP_IMG[2]
		#HTP_Title.text = ('GAMEPLAY')

func _on_Button_pressed():
	$"..".close('HTP')
	$"../PauseMenu".visible = true

func _on_LeftButton_pressed():
	_HTPset(currentSet-1)

func _on_RightButton_pressed():
	_HTPset(currentSet+1)

func openHTP():
	visible = true
func closeHTP():
	visible = false

func _on_HTP_EnlargeButton_toggled(button_pressed):
	if button_pressed:
		HTP_Enlarge()
	else:
		HTP_Original()

func HTP_Enlarge():
	$HTPMain/AnimationPlayer.play("HTP_Enlarge")
	yield(get_tree().create_timer(0.5), "timeout")

func HTP_Original():
	$HTPMain/AnimationPlayer.play_backwards("HTP_Enlarge")
	yield(get_tree().create_timer(0.5), "timeout")
