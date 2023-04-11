extends "res://InteractivePiece/_Master/Resource/InteractivePiece.gd"


export var Force = 250
export var power:float = 0.0
export var autoLaunch = false

var sample = preload('res://Resources/Effects/SFX/rlaunch.wav')

func _ready() -> void:
	parent_ready()

func launch():
	power = 1.0 if autoLaunch else power
	get_colliding_bodies().front().apply_impulse(Vector2.ZERO, Vector2.UP.rotated(global_rotation) * (Force*50) * power)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pull"):
		$AnimationPlayer.play("Pull")
	if Input.is_action_just_released("Pull"):
		$AnimationPlayer.stop()
		spawnFeedback(sample)
		if !get_colliding_bodies().empty():
			launch()
		$AnimationPlayer.play('FlashNewState', -1, 2.0)

func _on_Launcher_body_entered(_body: Node) -> void:
	if autoLaunch:
		Input.action_release("Pull")
