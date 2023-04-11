extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"

var origin = Vector2.ZERO
var size = Vector2.ONE

func _ready() -> void:
	parent_ready()
	size = scale
	$Sprite.scale = size
	$Anchor.scale = size
	$Collision.scale = size
	origin = $Anchor.global_position

func _physics_process(_delta: float) -> void:
	$Anchor.global_position = origin
	if angular_velocity > 5:
		$Sprite/Design.color = Color8(int(angular_velocity*5), int(angular_velocity*5), int(angular_velocity*5))
		$Sprite/Outline.default_color = Color8(int(angular_velocity*5), int(angular_velocity*5), int(angular_velocity*5))
	if angular_velocity < -5:
		$Sprite/Design.color = Color8(int(-angular_velocity*5), int(-angular_velocity*5), int(-angular_velocity*5))
		$Sprite/Outline.default_color = Color8(int(-angular_velocity*5), int(-angular_velocity*5), int(-angular_velocity*5))

func _on_Timer_timeout() -> void:
	if angular_velocity > 5 or angular_velocity < -5:
		emit_signal('addScore', ScoreVal)
		if trackHits:
			hits += 1
			emit_signal('Hit', self, $'../..'.tierNum)
