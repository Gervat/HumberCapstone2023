extends Area2D

signal ballDied(type)

func _on_DeathTrigger_body_entered(_body):
	yield(get_tree().create_timer(1.0, false), 'timeout')
	if !get_overlapping_bodies().empty():
		emit_signal("ballDied", 'Sink')
