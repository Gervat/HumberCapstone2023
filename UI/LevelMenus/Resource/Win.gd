extends Node2D

onready var hovered = true

func _process(_delta):
	if hovered == true: isButtonHovered()

func openWin():
	$AnimationPlayer.play_backwards("Win_Fade")
	yield(get_tree().create_timer(0.5), "timeout")

func closeWin():
	$AnimationPlayer.play("Win_Fade")
	yield(get_tree().create_timer(0.5), "timeout")

func isButtonHovered():
	if $Continue.is_hovered(): $Continue.modulate = Color(1, 1, 1)
	else: $Continue.modulate = Color(0, 0, 0)

func _on_Continue_pressed():
	$'../PerksSelection'.scene = Level.Next[Level.currentScene]
	closeWin()
	$"..".open('PerkSelection')
