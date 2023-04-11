extends Area2D

onready var EMan = get_node(Glob.EMan)
onready var player = $"../../../BallHandler/PlayerBall"
onready var cqPanel = $"../../ConquestPanel"
onready var boss = $"../../Boss"
onready var timer = $Timer

var isangry:bool = false

func _ready() -> void:
	if boss.connect("angry", self, "angry") != OK: Glob.Log("Cannot connect Boss Angry")
	if boss.connect("weak", self, "weak") != OK: Glob.Log("Cannot connect Boss Angry")
	isActive(false)

func isActive(v:bool):
	if !v:
		collision_mask = 2
		visible = false
	if v:
		collision_mask = 1
		visible = true

func _on_BossAttack_body_entered(body):
	if isangry ==  true: 
		print('entered ', body.name)
		timer.start(1)

func _on_BossAttack_body_exited(body):
	print('exited ', body.name)
	timer.stop()

func angry():
	isangry = true

func weak():
	isangry = false

func _on_Timer_timeout():
	EMan.addDamage(-2)
	print('fog damage applied')
