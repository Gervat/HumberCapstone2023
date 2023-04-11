extends Node2D

export(float) var orbitPower = 10.0

func _physics_process(_delta: float) -> void:
	rotation_degrees += orbitPower
	$ChaosArea.rotation_degrees -= orbitPower
	$ChaosArea/CollisionPolygon2D.global_position = global_position


func _on_Timer_timeout() -> void:
	$'../../../BallHandler'.moveBall("PopperSpawn", 1)


func _on_ChaosArea_body_entered(_body: Node) -> void:
	$Timer.start(rand_range(TAU, TAU+TAU))
