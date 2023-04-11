extends KinematicBody2D

export(bool) var locked:bool = false
export(bool) var open:bool = false setget toggle
var prevMask = collision_mask

func _ready():
	toggle(open)

func toggle(opened:bool) -> void:
	yield(get_tree(), 'idle_frame')
	if locked: return
	open = opened
	visible = !opened
	if opened:
		prevMask = collision_mask
		collision_mask = 0
	elif !opened:
		collision_mask = prevMask

