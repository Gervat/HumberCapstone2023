extends 'res://InteractivePiece/_Master/Resource/InteractivePiece.gd'

onready var EMan = get_node(Glob.EMan)

export(Vector2) var targetPos = Vector2.ZERO
export(float) var size:float = 1.0 setget resize
export(float) var BaseDamage:float = 3.0

var nudgeDir = Vector2.ZERO
var nudgeable:bool = true
var damageBoosted:bool = false
var currCollision = Vector2.ZERO
var prevCollision = Vector2.ZERO

var hitSample = preload('res://InteractivePiece/Balls/Resource/BallHit.mp3str')
onready var shader = $PowerUp
###===================================================================
###-------SYSTEM
###===================================================================
func _ready() -> void:
	set_meta('ball', true)
	if EMan.connect('LevelEvent', self, 'event') != OK: Glob.Log('EventFail: ' + name)
	size = 1
	if Perks.Perks['DamageUP']['active']: BaseDamage *= 1.5
	if connect('Damage', EMan, 'addDamage') != OK: Glob.Log('ConnectDamage Fail: ' + name)
	anim.play('Live')


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if state.get_contact_count() >= 1:
		prevCollision = currCollision
		currCollision = state.get_contact_local_position(0)

func _physics_process(_delta: float) -> void:
	$'../../HUD'.UpdateSpeedometer(sqrt(pow(linear_velocity.x, 2) + pow(linear_velocity.y, 2)))
	shader.global_rotation = 0
	$Trail.visible = !$NudgeEffect.emitting
	if $NudgeEffect.emitting: $Trail.removeAll()
	if Glob.Cheater:
		if Input.is_mouse_button_pressed(1):
			linear_velocity = Vector2.ZERO
			global_position = get_global_mouse_position()

	##NUDGE CONTROLS
	nudgeDir = Vector2(Input.get_action_strength("NudgeR") - Input.get_action_strength("NudgeL"), Input.get_action_strength("NudgeD") - Input.get_action_strength("NudgeU"))
	if Console.is_console_shown: return
	if nudgeable:
		if Input.is_action_just_pressed("NudgeU")\
			 or Input.is_action_just_pressed("NudgeD")\
			 or Input.is_action_just_pressed("NudgeL")\
			 or Input.is_action_just_pressed("NudgeR"):
				apply_impulse(-nudgeDir, nudgeDir * Glob.nudgeForce * 10)
				$NudgeEffect.emitting = true
				nudgeable = false
				yield(get_tree().create_timer(Glob.nudgeCooldown, false), 'timeout')
				nudgeable = true

###===================================================================
###-------UTILITY
###===================================================================
func set_floor(f):
	collision_mask = 4
	collision_layer = 4
	set_collision_mask_bit(f-1, true)
	set_collision_layer_bit(f-1, true)

func spawn():
	global_position = targetPos
	anim.play('Live')

func moveTo(pos):
	targetPos = pos
	linear_velocity = Vector2.ZERO
	$BugTimer.start()
	anim.play('Die')
###===================================================================
###-------SIGNALS
###===================================================================
func _on_PlayerBall_body_entered(body: Node) -> void:
	if currCollision.distance_to(prevCollision) > 60 and linear_velocity != Vector2.ZERO: spawnFeedback(hitSample, true)
	if body.is_in_group('Conquest'):
		emit_signal('Damage', getDmg(body.Lethal))
func getDmg(lethal) -> float:
	var LethalDamage:float
	if !lethal:
		BaseDamage *= Glob.damageBoost.Boost if damageBoosted else 1.0
		return BaseDamage * Glob.globalDamageMulti
	if lethal:
		LethalDamage = BaseDamage
		#if Glob.Perks['GlassCannon']['active']: LethalDamage = BaseDamage * 2
		return -LethalDamage

	return 1337.9001
###===================================================================
###-------SETGETS
###===================================================================
func resize(v):
	size = v
	$Collision.scale = Vector2(size,size)
	$Sprite.scale = Vector2(size,size)

func _on_BugTimer_timeout() -> void:
	if mode != MODE_RIGID:
		mode = MODE_RIGID
		print("Crude fix ACTIVATED!")

func event():
	if EMan.NAME == 'DamageBoost':
		if EMan.TYPE == 'SkillUsed':
			shader.visible = true
			damageBoosted = true
		if EMan.TYPE == 'SkillComplete':
			shader.visible = false
			damageBoosted = false

func perks():
	if Glob.Perks['BallSizeUP']['active']:
		resize(size + 0.1)
		weight += (weight * 0.25)
		#weight *= 1.25
	if Glob.Perks['BallSizeDOWN']['active']:
		resize(size - 0.1)
		weight -= (weight * 0.25)
		#weight *= 0.75

