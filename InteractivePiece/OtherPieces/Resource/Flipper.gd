extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"

export(bool) var LeftFlipper = false
export(float, 0.03, 0.1, 0.01) var Speed = 0.05
export(int) var restAngle = 35

var UpSample = preload('res://Resources/Effects/SFX/door03.wav')
var DownSample = preload('res://Resources/Effects/SFX/door05.wav')

var disabled = false

signal flip(direction)

func _ready() -> void:
	parent_ready()
	rotation_degrees = restAngle if !LeftFlipper else -restAngle

func _process(_delta: float) -> void:
	if !disabled:
		if (Input.is_action_just_pressed("LeftFlipper") and LeftFlipper)\
		or (Input.is_action_just_pressed("RightFlipper") and !LeftFlipper)\
		or Input.is_action_just_pressed("ui_up"): emit_signal("flip", 1)
		if (Input.is_action_just_released("LeftFlipper") and LeftFlipper)\
		or (Input.is_action_just_released("RightFlipper") and !LeftFlipper)\
		or Input.is_action_just_released("ui_up"): emit_signal("flip", 0)

func _on_Flipper_flip(direction) -> void:
	if direction == 1:
		spawnFeedback(UpSample)
		$Sprite/Outline.default_color = 0xffffffff
		$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, -restAngle - 70 if LeftFlipper else restAngle + 70, Speed)
		hits += 1
	if direction == 0:
		spawnFeedback(DownSample)
		$Sprite/Outline.default_color = 0x555555ff
		$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, -restAngle if LeftFlipper else restAngle, Speed)
	$Tween.start()
