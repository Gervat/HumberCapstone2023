extends 'res://InteractivePiece/_Master/Resource/InteractivePiece.gd'

var origin = Vector2.ZERO

func _ready() -> void:
	origin = $Anchor.global_position

func _physics_process(_delta: float) -> void:
	linear_velocity = Vector2.ZERO
	$Anchor.global_position = origin
