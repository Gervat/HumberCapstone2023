extends Node2D

export(String) var LevelName = 'BoardTemplate'
var Intro:bool = true

signal cheatDamage
onready var EMan = $EventManager
var prevCDs:Array = [1,1,1,1]
var music = [
	load('res://Resources/Music/MarchoftheAI.sample'),
	load('res://Resources/Music/Theme2.sample'),
	load('res://Resources/Music/Total Rekt\'em.sample')]
func _ready() -> void:
	$Menus.pause_mode = Node.PAUSE_MODE_STOP
	$IntroCutscene.visible = false
	Level.currentScene = LevelName
	name = 'Board'
	$Music.stream = music[randi() % music.size()]
	$GameManager/HUD.setMusic("Currently Playing: " + $Music.stream.resource_name.to_upper())
	$Music.play()
	if Glob.Cheater:
		Console.add_command('RunDMG', self)\
		.set_description('Inflict Damage (Negative values are enemy damage.)')\
		.add_argument('damage', TYPE_REAL)\
		.register()
		Console.add_command('Necromancy', self)\
		.set_description('Toggles DecaySpeeds')\
		.register()
		Console.add_command('NoChill', self)\
		.set_description('Toggles Skill Cooldowns')\
		.register()
		Console.add_command('TheGame', self)\
		.set_description('Loses the game')\
		.register()
		Console.add_command('NothingPersonel', self)\
		.set_description('Wins the game')\
		.register()

		#Change Tier's State

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('quentincaffeino_console_toggle'):
		get_tree().paused = Console.is_console_shown
	if Input.is_action_just_pressed("ui_cancel") and !Intro and !Console.is_console_shown: pause(!get_tree().paused)
### CONSOLE COMMANDS ===========================================================
func TheGame():
	$GameManager.emit_signal('EndGame', false)
func NothingPersonel():
	$GameManager.emit_signal('EndGame', true)
func NoChill():
	for i in Glob.EquippedSkills.size():
		if Glob.EquippedSkills[i]['Cooldown'] != 0: prevCDs[i] = Glob.EquippedSkills[i]['Cooldown']
		Glob.EquippedSkills[i]['Cooldown'] = 0 if Glob.EquippedSkills[i]['Cooldown'] != 0 else prevCDs[i]
func RunDMG(damage:float=100):
	print('Cheater!')
	if damage < -9000 or damage > 9000: $GameManager.Tier[$GameManager.currentTier-1].find_node("ConquestPanel").objDamage("THIS CAN'T BE HAPPENING!", damage)
	emit_signal('cheatDamage', damage)
func Necromancy():
	$GameManager/Tier1/ConquestPanel.DecaySpeed = 0 \
	if $GameManager/Tier1/ConquestPanel.DecaySpeed != 0 else 1
	$GameManager/Tier2/ConquestPanel.DecaySpeed = 0\
	if $GameManager/Tier2/ConquestPanel.DecaySpeed != 0 else 1
	$GameManager/Tier3/ConquestPanel.DecaySpeed = 0\
	if $GameManager/Tier2/ConquestPanel.DecaySpeed != 0 else 1
###=============================================================================


func pause(p:bool):
	if Intro: return
	get_tree().paused = p
	$PauseEffect.visible = get_tree().paused
	# Show PauseMenu
	$CameraMan.ZoomCam(false)
	$Menus.open('Pause') if p else $Menus.close('Pause')
	if !p: Input.action_release('ui_cancel')

func debugEvent(event ,type, eName, extra):
	print('Invalid ', event, 'Event: ', type, ', ', eName, ', ', extra )

### META EVENTS =======================================================================
func _on_MetaEvent() -> void:
	match EMan.TYPE:
		'Menu':
			MenuEvent(EMan.NAME, EMan.OTHER)
		'Cutscene':
			CutsceneEvent(EMan.NAME, EMan.OTHER)
		'Game':
			GameEvent(EMan.NAME, EMan.OTHER)
		_: debugEvent('Meta', EMan.TYPE, EMan.NAME, EMan.OTHER)
###=============================================================================
### READABLE EVENT HANDLES =====================================================
func MenuEvent(eName, extra):
	match eName:
		'Opened':
			match extra:
				'Pause':
					pass
				'PerkSelection':
					pass
				'HTP':
					pass
				'GameOver':
					pass
				'GameWin':
					pass
		'Closed':
			match extra:
				'Pause':
					pass
				'HTP':
					pass
				'Codex':
					pass
				_: debugEvent('Meta', 'Menu', eName, extra)
		_: debugEvent('Meta', 'Menu', eName, extra)
func CutsceneEvent(eName, extra):
	match eName:
		'Started':
			match extra: # Cutscene name
				'Opening':
					pass
				'Epilogue':
					pass
				'Boss':
					pass
				_: debugEvent('Meta' ,'Cutscene', eName, extra)
		'Complete':
			match extra: # Cutscene name
				'Opening':
					pass
				'Epilogue':
					pass
				'Boss':
					pass
				_: debugEvent('Meta' ,'Cutscene', eName, extra)
		_: debugEvent('Meta' ,'Cutscene', eName, extra)
func GameEvent(eName, extra):
#		Game:
#			Finished(Win/Lose)
#			Paused(true/false)
#			PerkChosen(perk)
	match eName:
		'Finished': #Win/Lose true/false
			if extra == 'Win':
				$Menus.open('Win')
			elif extra == 'Lost':
				$Menus.open('Lost')
		'PerkChosen':
			Glob.Perks[extra] = true
		_: debugEvent('Meta', 'Game', eName, extra)

###=============================================================================
func _on_LevelEvent() -> void:
	if EMan.TYPE == 'Area' and EMan.TIER == 3: $CameraMan.ZoomCam(EMan.NAME == 'Entered')

func _exit_tree() -> void:
	Console.remove_command('RunDMG')
	Console.remove_command('Necromancy')
	Console.remove_command('NoChill')
	Console.remove_command('TheGame')
	Console.remove_command('NothingPersonel')

