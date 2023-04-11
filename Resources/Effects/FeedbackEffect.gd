extends Node2D

var soundComplete = false
var emit = false
var sound = null
var initialPos = Vector2.ZERO
func _ready():
	soundComplete = false
	global_position = initialPos
	$Sound.stream = sound
	$Sound.play()
	$Particles.global_position = initialPos
	$Particles.emitting = emit

func _process(_delta: float) -> void:
	if !$Particles.emitting and soundComplete: queue_free()

func _on_Sound_finished() -> void:
	soundComplete = true
