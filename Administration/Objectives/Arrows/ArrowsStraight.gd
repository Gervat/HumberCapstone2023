extends Node2D

func idle():
	$AnimationPlayer.play('Idle')
func blink():
	$AnimationPlayer.play('Blink')
