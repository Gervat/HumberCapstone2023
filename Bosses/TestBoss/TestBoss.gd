extends Node2D

enum{AWAKEN=0, ANGRY=1, WEAK=2, SLEEP=3}
var currState:int = AWAKEN setget updateState

onready var sleep = $States/Sleep
onready var sleepsprite = $States/Sleep/Sprite
onready var awaken = $States/Awaken
onready var awakensprite = $States/Awaken/Sprite
onready var angry = $States/Angry
onready var angrysprite = $States/Angry/Sprite
onready var weak = $States/Weak
onready var weaksprite = $States/Weak/Sprite

onready var hit1 = $"../Objectives/HitObjective1"
onready var hit2 = $"../Objectives/HitObjective2"
onready var attackboss1 = $"../Objectives/AttackBoss1"
onready var attackboss2 = $"../Objectives/AttackBoss2"
onready var bumper1 = $"../IntPieces/BumperL"
onready var bumper2 = $"../IntPieces/BumperR"

onready var attackspawn = $"../SpawnPoints/AttackBossSpawn"
onready var player = $"../../BallHandler/PlayerBall"

signal angry
signal weak

func _ready() -> void:
	updateState(SLEEP)

func updateState(v):
	currState = v
	match currState:
		AWAKEN:
			awaken.collision_mask = 1
			awakensprite.self_modulate.a = 1
			sleep.collision_mask = 2
			sleepsprite.self_modulate.a = 0
			angry.collision_mask = 2
			angrysprite.self_modulate.a = 0
			weak.collision_mask = 2
			weaksprite.self_modulate.a = 0

			$States/Awaken/AnimationPlayer.play("Awaken")
			yield(get_node("States/Awaken/AnimationPlayer"), "animation_finished")
			updateState(ANGRY)

		ANGRY:
			awaken.collision_mask = 2
			awakensprite.self_modulate.a = 0
			sleep.collision_mask = 2
			sleepsprite.self_modulate.a = 0
			angry.collision_mask = 1
			angrysprite.self_modulate.a = 1
			weak.collision_mask = 2
			weaksprite.self_modulate.a = 0

			$States/Angry/AnimationPlayer.play("Idle")
			emit_signal("angry")

		WEAK:
			awaken.collision_mask = 2
			awakensprite.self_modulate.a = 0
			sleep.collision_mask = 2
			sleepsprite.self_modulate.a = 0
			angry.collision_mask = 2
			angrysprite.self_modulate.a = 0
			weak.collision_mask = 1
			weaksprite.self_modulate.a = 1
			emit_signal("weak")

		SLEEP:
			awaken.collision_mask = 2
			awakensprite.self_modulate.a = 0
			sleep.collision_mask = 1
			sleepsprite.self_modulate.a = 1
			angry.collision_mask = 2
			angrysprite.self_modulate.a = 0
			weak.collision_mask = 2
			weaksprite.self_modulate.a = 0

#When Player first enters arena, will awaken the boss to start the fight
func _on_BossSpawnTrigger_PlayerEntered():
	updateState(AWAKEN)

# First Hit Objective Complete, transition boss to WEAK state
func _on_HitObjective_objectiveComplete(_name, _obj):
	updateState(WEAK)

	$"../IntPieces/BumperL".collision_mask = 2
	$"../IntPieces/BumperL".modulate.a = 0
	$"../IntPieces/BumperR".collision_mask = 2
	$"../IntPieces/BumperR".modulate.a = 0

	$"../IntPieces/BumperL2".collision_mask = 1
	$"../IntPieces/BumperL2".modulate.a = 1
	$"../IntPieces/BumperR2".collision_mask = 1
	$"../IntPieces/BumperR2".modulate.a = 1

# First Attack Boss Objective Complete, transition boss to ANGRY state
func _on_AttackBoss_objectiveComplete(_name, _obj):
	updateState(ANGRY)

# Second Hit Objective Complete, transition boss to WEAK state
func _on_HitObjective2_objectiveComplete(_name, _obj):
	updateState(WEAK)

# Second Attack Boss Objective Complete, transition boss to ANGRY state
# This shouldn't even be needed as boss should be dead before this completes
func _on_AttackBoss2_objectiveComplete(_name, _obj):
	updateState(ANGRY)


func _on_Set_SetTrigger(type, _name, _tier):
	if type == 'Unlocked':
		hit1.complete = true

func _on_Set2_SetTrigger(type, _name, _tier):
	if type == 'Unlocked':
		hit2.complete = true

func AttackBoss1ObjTimer():
	attackboss1.complete = true

func AttackBoss2ObjTimer():
	attackboss2.complete = true


