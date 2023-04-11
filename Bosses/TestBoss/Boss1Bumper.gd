extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"


export var strength = 5000
export var sensitivity = 5

var direction
var rng = RandomNumberGenerator.new()
var spin = 0.0

#onready var bumpSample = preload('res://Resources/Effects/SFX/tick.wav')
func _ready() -> void:
	parent_ready()
	State = Glob.DEFAULT
	if Perks.Perks['BumperForceUP']['active']: strength += strength * 0.75
	if Perks.Perks['BumperForceDOWN']['active']: strength -= strength * 0.75
	if Perks.Perks['BumperScoreUP']['active']: BaseScoring *= 2

func _on_Bumper_body_entered(body: Node) -> void:
	rng.randomize()
	spin = rng.randf_range(-0.7854, 0.7854) #Randomized direction for fun

	if body.linear_velocity < Vector2(-sensitivity, -sensitivity)\
	or body.linear_velocity > Vector2(sensitivity, sensitivity):
		#if !anim.is_playing(): anim.play("Bump")
		#spawnFeedback(bumpSample)
		direction = global_position.direction_to(body.global_position).rotated(spin)
		body.linear_velocity = Vector2.ZERO
		emit_signal("addScore", ScoreVal)
		if trackHits:
			hits += 1
			#                         hope this is always correct
			if $"../../..".tierNum: emit_signal('Hit', self, $'../../..'.tierNum)

		body.apply_impulse(Vector2.ZERO, direction + (direction * strength))
