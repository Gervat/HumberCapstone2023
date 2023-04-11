extends CanvasLayer

signal menu(mName, opened)

onready var scoreLabelWin = $Win/Score
onready var scoreLabelLost = $Lost/Score
onready var HUD = get_node(Glob.HUD)
onready var EMan = get_node(Glob.EMan)

func _ready():
	if connect('menu', EMan, 'menuEvent') != OK: Glob.Log('Connect MenuEvent Failed')
	$Win.visible = false
	$Lost.visible = false
	$PerksSelection.visible = false
	visible = true

func event():
	if EMan.TYPE == 'Game':
		if EMan.NAME == 'Win': open('Win')
		if EMan.NAME == 'Lost': open('Lost')

func open(menuName:String):
	$"..".pause_mode = Node.PAUSE_MODE_STOP
	match menuName:
		'PerkSelection':
			$PerksSelection.openPerkSelection()
			emit_signal('menu', 'PerkSelection', true)
		'Pause':
			$"..".pause_mode = Node.PAUSE_MODE_PROCESS
			$PauseMenu.openPauseMenu()
			emit_signal('menu', 'Pause', true)
		'HTP':
			$HTP.openHTP()
			emit_signal('menu', 'HTP', true)
		'Win':
			get_tree().paused = true
			$Win.openWin()
			scoreLabelWin.text = str(HUD.getScore())
			emit_signal('menu', 'Win', true)
		'Lost':
			get_tree().paused = true
			$Lost.openLost()
			scoreLabelLost.text = str(HUD.getScore())
			emit_signal('menu', 'Lost', true)


func close(menuName:String):
	$"..".pause_mode = Node.PAUSE_MODE_PROCESS
	match menuName:
		'PerkSelection':
			$PerksSelection.closePerkSelection()
			emit_signal('menu', 'PerkSelection', false)
		'Pause':
			$PauseMenu.closePauseMenu()
			emit_signal('menu', 'Pause', false)
		'HTP':
			$HTP.closeHTP()
			emit_signal('menu', 'HTP', false)
		'Win':
			$Win.closeWin()
			emit_signal('menu', 'Win', false)
		'Lost':
			$Lost.closeLost()
			emit_signal('menu', 'Lost', false)
