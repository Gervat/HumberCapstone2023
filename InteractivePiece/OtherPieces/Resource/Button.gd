extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"

enum{DISABLED=0, LOCKED=1, ON=2, OFF=3}

# warning-ignore:unused_class_variable
export(int, LAYERS_3D_PHYSICS) var codePos = 1
var currState:int = OFF setget updateState

func _ready() -> void:
	ScoreVal = BaseScoring
	updateState(OFF)

func updateState(v):
	currState = v
	match currState:
		DISABLED:
			$AnimationPlayer.play("Disabled")
		LOCKED:
			contact_monitor = false
		OFF:
			yield(get_tree().create_timer(0.01, false), 'timeout')
			contact_monitor = true
			$AnimationPlayer.play("TurnOff")
		ON:
			contact_monitor = true
			$AnimationPlayer.play("TurnOn")

func changeLights():# So we don't anger Mom & Dad
	pass

func _on_Button_body_entered(body: Node) -> void:
	if body.is_in_group("Ball"):
		match currState:
			LOCKED: pass
			OFF:
				updateState(ON)
				emit_signal("addScore", BaseScoring)
				if trackHits:
					hits += 1
					emit_signal('Hit', self, $'../..'.tierNum)
			ON:
				if trackHits:
					hits += 1
					emit_signal('Hit', self, $'../..'.tierNum)
				updateState(OFF)

