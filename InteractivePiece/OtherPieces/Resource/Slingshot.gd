extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"

export(int) var strength = 33
export(bool) var straight= false

onready var Mid = $Middle.global_position
onready var radius = $Area2D/Slingshot.shape.height / 2

var direction = Vector2.ZERO
var power = 1

var shotSample = preload('res://Resources/Effects/SFX/tick.wav')

func _ready() -> void:
	parent_ready()
	if Perks.Perks['SlingshotForceUP']['active']: strength += strength * 0.75
	if Perks.Perks['SlingshotForceDOWN']['active']: strength -= strength * 0.75
	if Perks.Perks['SlingshotScoreUP']['active']: BaseScoring *= 2
	if is_in_group('Conquest'):
		remove_from_group('Conquest')
		$Area2D.add_to_group('Conquest')
	$Area2D.collision_layer = collision_layer
	$Area2D.collision_mask = collision_mask


func _on_Area2D_body_entered(body: Node) -> void:
	spawnFeedback(shotSample)
	direction = $ForceFocus.global_position.direction_to(body.global_position) if !straight else -$ForceFocus.global_position.direction_to($ForceFocus.cast_to)
	body.linear_velocity = Vector2.ZERO
	power = radius / (radius + Mid.distance_squared_to(body.global_position)) if !straight else 1
	body.apply_impulse(Vector2.ZERO, direction * strength * 100)
	emit_signal("addScore", ScoreVal)
	if body.has_signal('Damage') and $Area2D.is_in_group("Conquest"): body.emit_signal('Damage', body.getDmg(Lethal))
	if trackHits:
		hits += 1
		emit_signal('Hit', self, $'../..'.tierNum)
	if !$AnimationPlayer.is_playing(): $AnimationPlayer.play("Sling")
