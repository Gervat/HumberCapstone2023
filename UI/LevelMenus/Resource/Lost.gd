extends Node2D

onready var hovered = true

func _process(_delta):
	if hovered == true: isButtonHovered()

func openLost():
	$AnimationPlayer.play_backwards("Lost_Fade")
	yield(get_tree().create_timer(0.5), "timeout")

func closeLost():
	$AnimationPlayer.play("Lost_Fade")
	yield(get_tree().create_timer(0.5), "timeout")

func isButtonHovered():
	if $Continue.is_hovered(): $Continue.modulate = Color(1, 1, 1)
	else: $Continue.modulate = Color(0, 0, 0)

func _on_Continue_pressed():
	$'../PerksSelection'.scene = Level.Replay[Level.currentScene]
	closeLost()
	$"..".open('PerkSelection')
