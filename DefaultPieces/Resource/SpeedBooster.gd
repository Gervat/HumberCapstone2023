extends Area2D

export var enabled = true setget toggle
export var power = 2048 setget setPower
export var Static:bool = false
var prevColor:Color
var FeedbackEffect = preload("res://Resources/Effects/FeedbackEffect.tscn")
var zoom = null
var ssample = preload('res://Resources/Effects/SFX/SFX_Powerup_01.wav')

func _ready():
	prevColor = $Sprite.color
	gravity_vec = Vector2.UP.rotated(global_rotation)
	gravity = power * 5
	monitoring = enabled
# warning-ignore:incompatible_ternary
	$Sprite.color = prevColor if enabled else 0xff00ff00

func setPower(v):
	power = v
	gravity = power
	if !is_inside_tree(): return
	gravity_vec = Vector2.UP.rotated(global_rotation)

func toggle(v):
	enabled = v
	monitoring = enabled
	$Sprite.color = 0xddddddff if enabled else 0x111111ff

#Borrowed from InteractivePiece
func spawnFeedback(sample=load('res://Resources/Effects/UHOH.mp3str'), withParticles=false):
	var feedback = FeedbackEffect.instance()
	feedback.initialPos = global_position
	feedback.emit = withParticles
	feedback.sound = zoom if zoom else sample
	self.add_child(feedback)

func _on_SpeedBooster_body_entered(body: Node) -> void:
	if body.is_in_group("Ball"):
		if Static: body.linear_velocity = Vector2.ZERO
		spawnFeedback(ssample)
