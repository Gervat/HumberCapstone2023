extends Node2D

export var openOnStart:bool = false
onready var batteries = get_children()

signal damaged
signal overload

func _ready() -> void:
	for i in batteries.size():
		batteries[i].shown = openOnStart
		batteries[i].connect('damaged', self, '_on_damaged')
		batteries[i].connect('overload', self, '_on_overload')

func checkShown() -> bool:
	for i in batteries.size():
		if batteries[i].shown and !batteries[i].enemy:
			return true
	return false

func _on_damaged():
	emit_signal('damaged')
func _on_overload():
	emit_signal('overload')
