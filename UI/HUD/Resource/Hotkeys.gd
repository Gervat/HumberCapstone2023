extends Node2D

onready var Hotkeys = [$SkillIconN, $SkillIconE, $SkillIconS, $SkillIconW]
onready var SkillsEman = get_node(Glob.EMan)

func _ready():
	if is_inside_tree():
		Hotkeys[0].texture = load(Glob.EquippedSkills[0].HotkeySprite)
		Hotkeys[1].texture = load(Glob.EquippedSkills[1].HotkeySprite)
		Hotkeys[2].texture = load(Glob.EquippedSkills[2].HotkeySprite)
		Hotkeys[3].texture = load(Glob.EquippedSkills[3].HotkeySprite)
	SkillsEman.connect('LevelEvent', self, 'event')


func event()-> void:
	match SkillsEman.TYPE:
		'SkillUsed':
			Hotkeys[SkillsEman.OTHER].play('Flash')
			if Glob.EquippedSkills[SkillsEman.OTHER].has('Duration'):
				Hotkeys[SkillsEman.OTHER].queue("Active")
			else: Hotkeys[SkillsEman.OTHER].queue("Disabled")
		'SkillComplete':
			print('Skill Completed: ', SkillsEman.OTHER)
			Hotkeys[SkillsEman.OTHER].play('Disabled')
		'SkillCooled':
			Hotkeys[SkillsEman.OTHER].play("Available")
