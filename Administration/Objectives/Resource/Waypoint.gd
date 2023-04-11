extends Node2D

var ref
var refPos:Vector2
onready var screenRect:Control = $".."

func _physics_process(_delta: float) -> void:
	refPos = ref.get_global_transform_with_canvas().origin
	look_at(refPos)
	global_position.x = clamp(refPos.x, screenRect.rect_global_position.x, screenRect.rect_global_position.x + screenRect.rect_size.x)
	global_position.y = clamp(refPos.y, screenRect.rect_global_position.y, screenRect.rect_global_position.y + screenRect.rect_size.y)
	visible = !(global_position == refPos) and ref.visible
