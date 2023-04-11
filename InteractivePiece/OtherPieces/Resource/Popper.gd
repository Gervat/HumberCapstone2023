extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"

export(int) var launchForce = 3000
onready var ball

var sample = preload('res://Resources/Effects/SFX/slimeball.wav')

func _ready() -> void:
	parent_ready()
	$Area2D.collision_layer = collision_layer
	$Area2D.collision_mask = collision_mask

func launch():
	if ball and is_instance_valid(ball):
		if ball.is_in_group("Ball"):
			ball.apply_impulse(Vector2.ZERO, Vector2.UP.rotated(rotation) * launchForce)
			ball = null
			if trackHits:
				hits += 1
				emit_signal('Hit', self, $"../..".tierNum)
			spawnFeedback(sample)

func _on_Area2D_body_entered(body):
	ball = body
	body.linear_velocity = Vector2.ZERO
	if body.is_in_group("Ball"): $AnimationPlayer.play("Launch")
