extends Node

# Operational Reaction Ballistic - O.R.B.
# Capacitors - Bumper
# Diverter - Slingshot
export var Perks:Dictionary = {
	FCBallsUP={Name='Squared Echo', Desc='Adds 16 Echos to Mass Echo.', Type='Plus', active=false},
	FCDamageUP={Name='Lethal Echo', Desc='Allows Mass Echo to damage.', Type='Up', active=false},
	FCDurationUP={Name='Reverbed Echo', Desc="Extends Mass Echo's duration by 10 seconds.", Type='Plus', active=false},
	SlowCDDOWN={Name='Frequent Focus', Desc='Reduces cooldown of Total Focus by 30 seconds.', Type='Minus', active=false},
	SlowDurationUP={Name='Extended Focus', Desc='Extends Total Focus duration by 3 seconds.', Type='Plus', active=false},
	SpawnLCD={Name='Quick Retreat Left', Desc='Reduces Quick Retreat Left\'s cooldown by 15 seconds.', Type='Minus', active=false},
	SpawnRCD={Name='Quick Retreat Right', Desc='Reduces Quick Retreat Left\'s cooldown by 15 seconds.', Type='Minus', active=false},
	NudgeCD={Name='Quick Recharge O.R.B.', Desc='Decreases Impulse cooldown by 25%.', Type='Minus', active=false},
	NudgeForce={Name='Impactful Impulse', Desc='Increases Impulse force by 250%.', Type='Up', active=false},
	DamageUP={Name='Lethal O.R.B.', Desc='Increased base damage of O.R.B. by 50%.', Type='', active=false},
	BallSizeUP={Name='Over Compensation', Desc='Increased O.R.B. size.', Type='Up', active=false},
	BallSizeDOWN={Name='Inferiority Complex', Desc='Decreased O.R.B. size.', Type='Down', active=false},
	BumperForceUP={Name='1.21 Gigawatts', Desc='Increases Capacitor impact.', Type='Up', active=false},
	BumperForceDOWN={Name='Drained Capacitors', Desc='Decreases Capacitor impact.', Type='Down', active=false},
	BumperScoreUP={Name='Capacitor Data++', Desc='Increased data collection from Capacitor.', Type='Plus', active=false},
	SlingshotForceUP={Name='Strong Divergence', Desc='Increased Diverter power.', Type='Up', active=false},
	SlingshotForceDOWN={Name='Weak Divergence', Desc='Decreased Diverter power.', Type='Down', active=false},
	SlingshotScoreUP={Name='Diverter Data++', Desc='Increases data collection from Diverter.', Type='Plus', active=false},
	BallsUP={Name='Big Pockets', Desc='Carry 2 extra O.R.B.s', Type='Plus', active=false},
	DecayResist={Name='Synchronized', Desc='Increases Companion\'s ability to hold off enemy.', Type='Minus', active=false},
	BallSaverTimeUP={Name='Helping Hand', Desc='Companion protects you for 10 more seconds.', Type='Plus', active=false},
	AllIn={Name='All-In', Desc='No extra O.R.B.s, but maximum data extraction rate.', Type='Unique', active=false},
	Shotgun={Name='Shotgun', Desc='Carry double the amount of O.R.B.s, but half the data extraction rate.', Type='Unique', active=false},
	HighImpact={Name='High Impact', Desc='Double the damage, double the weight.', Type='Unique', active=false},
	DivertPower={Name='Fight No Flight', Desc='Disables Retreat, increases O.R.B. impulse.', Type='Unique', active=false},
	PureSkill={Name='Pure Skill', Desc='Diverts impulse circuits to base damage.', Type='Unique', active=false},
	GottaGo={Name='Bodyguard', Desc='Companion always protect\'s you instead of holding back enemy.', Type='Unique', active=false},
	GlassCannon={Name='Glass Cannon', Desc='Double damage on both sides.', Type='Unique', active=false}
	}


func activatePerk(perk):
	if !Perks[perk]['active']:
		Perks[perk]['active'] = true
	else:
		print("Perk already true!")
		return
	match perk:
		'FCBallsUP': Glob.fusterCluck.Amount += 16
		'FCDurationUP': Glob.fusterCluck.Duration += 10.0
		'FCDamageUP': Glob.fusterCluck.Damage = 1.5
		'SlowCDDOWN': Glob.slowTime.Cooldown += -30.0
		'SlowDurationUP': Glob.slowTime.Duration += 3.0
		'SpawnLCD': Glob.spawnLeft.Cooldown += -15.0
		'SpawnRCD': Glob.spawnRight.Cooldown += -15.0
		'NudgeCD': Glob.nudgeCooldown *= 0.75
		'NudgeForce': Glob.nudgeForce *= 2.5
		'DecayResist': Glob.decayResist = 2.5
		'HighImpact':
			Glob.globalDamageMulti = 2.0
			Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 196)
		'DivertPower':
			Glob.nudgeCooldown *= 0.33
			Glob.nudgeForce *= 3.0
			for i in Glob.EquippedSkills.size():
				if Glob.EquippedSkills[i] == Glob.spawnLeft\
				or Glob.EquippedSkills[i] == Glob.spawnRight:
					Glob.EquippedSkills[i] = Glob.noSkill
		'PureSkill':
			Glob.nudgeCooldown = 5318008.0
			Glob.nudgeForce = 0.0
			Glob.globalDamageMulti = 4.0
		'GlassCannon': Glob.globalDamageMulti = 2.0
