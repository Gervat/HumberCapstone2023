extends "res://InteractivePieces/Templates/Resource/InteractivePiece.gd"

export(bool) var OneWay = true
export(bool) var Open = false
export(bool) var Repellant = false

var sound = preload("res://Resources/UHOH.mp3str")

signal hit(piece)

func _ready():
	$Collision.one_way_collision = OneWay
	$Collision.disabled = Open
	if Repellant: visible = !Open


func _on_Gate_body_entered(body: Node) -> void:
	spawnFeedback(sound)
	emit_signal("hit", name)
	if Repellant: body.apply_impulse(Vector2.ZERO, -global_position.direction_to(body.global_position) * 25)
func oneWay(v):
	OneWay = v
	$Collision.one_way_collision = OneWay
func open(v):
	Open = v
	$Collision.disabled = Open
	if Repellant: visible = !Open
