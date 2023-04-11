extends Area2D

signal PlayerEntered

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "PlayerBall":
			emit_signal("PlayerEntered")
			queue_free()

func _ready():
	pass
