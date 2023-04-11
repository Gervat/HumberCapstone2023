extends Area2D

var initiated:bool = false

export(float) var DamageTick = PI / 2
export(float) var ChargeTime = PI
export(float) var FireTime = TAU

enum{CHARGING, FIRING, OFF}

var currState
var end:Vector2 = Vector2.ZERO# wall point
var distanceToCollision
var d:float = 0.0 # delta storage
var offset:float = 1.0

onready var raycast = $RayCast2D #does NOT collide with ball
onready var hitbox = $HitBox
onready var beam = $Sprite
onready var endParticles = $EndParticles
onready var hitRate = $HitRate

var hitboxpoly = [Vector2.ZERO]

signal FiringComplete
signal EnemyDamaged

func _ready() -> void:
	if get_parent(): offset = position.x
	visible = true
	$Charge.emitting = false
	$Muzzle.emitting = false
	$EndParticles.emitting = false
	$EndParticles.global_position = end
	end = global_position
	collision_mask = 0
	hitbox.polygon[2].x = end.x
	hitbox.polygon[3].x = end.x
	currState = OFF

func _physics_process(delta: float) -> void:
	d = delta
	if raycast.is_colliding():
		end = raycast.get_collision_point()
		endParticles.global_position = raycast.get_collision_point()
	# if raycast.is_colliding() else Vector2(5000,0)
	else:
		end = Vector2(5000, 0)
		endParticles.global_position = Vector2(5000,5000)
	if currState == CHARGING:
		updateBeam()
		if beam.material.get_shader_param("progress") != 0.1:
			beam.material.set_shader_param("progress", move_toward(beam.material.get_shader_param("progress"), 0.1, d*TAU * PI))

	if currState == FIRING:
		updateBeam()
		if beam.material.get_shader_param("progress") < 1:
			beam.material.set_shader_param("progress", move_toward(beam.material.get_shader_param("progress"), 1.0, d*TAU * PI))

	if currState == OFF and beam.material.get_shader_param("progress") > 0.0:
		beam.material.set_shader_param("progress", move_toward(beam.material.get_shader_param("progress"), 0.0, d*TAU * PI))

func startBlasting():
	initiated = true
	currState = CHARGING
	$Charge.emitting = true
	if $Timer.time_left == 0: $Timer.start(ChargeTime)

func FireZeLasers():
	currState = FIRING
	collision_mask = 1
	$Charge.emitting = false
	$Muzzle.emitting = true
	endParticles.emitting = true

	if $Timer.time_left == 0: $Timer.start(FireTime)

func powerDown():
	currState = OFF
	collision_mask = 0
	$Charge.emitting = false
	$Muzzle.emitting = false
	endParticles.emitting = false
	emit_signal("FiringComplete")
	initiated = false

func updateBeam():
	#UPDATE ENDS
	if end.x < 0: end.x *= -1 #UNSIGNED INT
	distanceToCollision = global_position.distance_to(end)
	beam.remove_point(1)
	beam.add_point(Vector2((position.x + distanceToCollision) - offset, position.y))

	hitboxpoly = [Vector2(0, 24), Vector2(0, -24), Vector2(distanceToCollision, -24), Vector2(distanceToCollision, 24)]
	hitbox.polygon = hitboxpoly

func _on_Timer_timeout() -> void:
	if currState == FIRING:
		powerDown()
	if currState == CHARGING: #FIRE ZE LASERS
		FireZeLasers()

func _on_HitRate_timeout() -> void:
	if currState == FIRING:
		collision_mask = 1

func _on_Laser_body_entered(body: Node) -> void:
	if body.has_signal("ball"):
		hitRate.start(DamageTick * d)
		collision_mask = 0
		emit_signal("EnemyDamaged")

