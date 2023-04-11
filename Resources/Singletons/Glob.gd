extends Node

#STATES - for lighting
enum {OFF=1, DEFAULT=2, PLAYER=4, OCCUPIED=8, ENEMY=16}
#Top Global
export(bool) var Cheater = true
var DebugLog = File.new()

var SaveFile = File.new()
var save:Dictionary = {
	exists = true,
	SaveName = 'Player1',
	PerksActive = Perks,
	Currency = currency,
	SkillsEquipped = EquippedSkills
}
var save_data = JSON.print(save)

#Cross Level
# warning-ignore:unused_class_variable
var nudgeCooldown = 1.0
var nudgeForce = 150
# warning-ignore:unused_class_variable
var currency:int = 0
var NudgeAmp:float = 1.5
var damageAmp:float = 1.0
# warning-ignore:unused_class_variable
var globalDamageMulti = 1.0
# warning-ignore:unused_class_variable
var decayResist:float = 0.0

#Skills Related
var damageBoost:Dictionary = {Name="Overheat", Cooldown=20.0, Duration=10.0, Boost=1.1, Description='', HotkeySprite = "res://UI/HUD/Resource/IMG/Skill_SlowTime.png"}
var blockAttack:Dictionary = {Name="Return Null", Description='', Cooldown=25.0, Duration=3.0, HotkeySprite = "res://UI/HUD/Resource/IMG/Skill_SlowTime.png"}
var fusterCluck:Dictionary = {Name="Mass Echo", Description='', Cooldown=15.0, Damage=1.0, Duration=3.0, Amount=16, Explosiveness=5000, HotkeySprite = 'res://UI/HUD/Resource/IMG/Skill_FusterCluck.png'}
var slowTime:Dictionary = {Name="Total Focus", Description='' , Cooldown=120.0, Duration=3.0, HotkeySprite = "res://UI/HUD/Resource/IMG/Skill_SlowTime.png"}
var unlimitedNudge:Dictionary = {Name="Argon Impulse", Description='', Cooldown=15.0, Duration=3.0, NudgeForce=nudgeForce * NudgeAmp, HotkeySprite = "res://UI/HUD/Resource/IMG/Skill_SlowTime.png"}
var spawnLeft:Dictionary = {Name='Regroup Left', Description='', Cooldown=30.0, HotkeySprite = 'res://UI/HUD/Resource/IMG/Skill_LeftSpawn.png'}
var spawnRight:Dictionary = {Name='Regroup Right', Description='', Cooldown=30.0, HotkeySprite = 'res://UI/HUD/Resource/IMG/Skill_RightSpawn.png'}
var noSkill:Dictionary = {Name="Nil", Description='', HotkeySprite = "res://UI/HUD/Resource/IMG/Skill_SlowTime.png"}
#---------------------------------------------------------------------
# warning-ignore:unused_class_variable
var EquippedSkills = [fusterCluck, spawnRight, slowTime, spawnLeft]
#    Dpad Direction:      up            right         down        left
#---------------------------------------------------------------------

var EMan = "/root/Board/EventManager"
var HUD = "/root/Board/GameManager/HUD"

func _ready():
	#if Cheater: Perks.activatePerk('FCDamageUP')
# DESCRIPTIONS

	if DebugLog.open('user://Pinball.txt', File.WRITE_READ) != OK: print('DebugLog Failed to create, Code: ', DebugLog.open('user://Pinball.txt', File.WRITE_READ))
	saveGame()

	print("Setting up skill descriptions...")
	Log('Setting up skill Descriptions...', false)
#---------------------------------------------------------------------
	noSkill.Description = 'Insert a skill to use in battle!'
#---------------------------------------------------------------------
	damageBoost.Description = 'Boosts the damage received by ' + str(damageBoost.Boost) + ' for ' + str(damageBoost.Duration) + ' seconds.'
#---------------------------------------------------------------------
	blockAttack.Description = 'Automatically counters all attacks for ' +  str(blockAttack.Duration) + ' seconds.'
#---------------------------------------------------------------------
	fusterCluck.Description = 'Explode your ball into ' + str(fusterCluck.Amount) + ' Echo Balls. Echos despawn after ' + str(fusterCluck.Duration) + ' seconds.'
#---------------------------------------------------------------------
	slowTime.Description = 'Boost Reaction time by 50% for ' + str(slowTime.Duration * 2) + ' seconds.'
#---------------------------------------------------------------------
	unlimitedNudge.Description = 'Overcharge your impulse ability for ' + str(unlimitedNudge.Duration) + ' seconds.'
#---------------------------------------------------------------------
	spawnLeft.Description = 'Respawn the ball near the Left Flipper'
	spawnRight.Description = 'Respawn the ball near the Right Flipper'
#---------------------------------------------------------------------
	print(" ...done.")
	Log(' Done.')
func _exit_tree() -> void:
	saveGame()
	DebugLog.close()
	queue_free()

func saveGame():
	DebugLog.close()
	SaveFile.open('user://Pinball.sav', File.WRITE)
	SaveFile.store_line(JSON.print(save_data))
	SaveFile.close()

	DebugLog.open('user://RebelHead/Debug/Pinball.txt', File.WRITE_READ)

func loadGame():
	pass

func Log(text:String, endl:bool=true):
	if DebugLog.is_open():
		if endl: DebugLog.store_string(text + '\n')
		else: DebugLog.store_string(text)

func DebugSafetyTimeOut() -> void:
	if DebugLog.is_open(): DebugLog.flush()
