extends RigidBody2D

signal damage

var size:float = 1

func _ready() -> void:
	mode = RigidBody2D.MODE_RIGID
	$AnimationPlayer.play("RESET")

func die():
	global_position = Vector2(8008135, -8008135)
	yield(get_tree().create_timer(3),'timeout')
	$AnimationPlayer.play("Die")
	yield($AnimationPlayer, 'animation_finished')
	queue_free()

func _on_FusterCluck_body_entered(body: Node) -> void:
	if body.is_in_group('Conquest'):
		emit_signal('damage', Glob.fusterCluck['Damage'] * Glob.globalDamageMulti)
