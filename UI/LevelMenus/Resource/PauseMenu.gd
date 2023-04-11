extends Node2D

onready var hovered = true

var perkIcon = preload('res://UI/Resource/PerkNode/PerkNode.tscn')
var perkArray:Array = Perks.Perks.keys()

func _ready() -> void:
	#$Perks/ActivePerks.get_children().clear()
	for i in perkArray.size():
		if Perks.Perks[perkArray[i]]['active']:
			var newIcon = perkIcon.instance()
			$Perks/ActivePerks.add_child(newIcon)
			newIcon.set_owner($Perks/ActivePerks)
			newIcon.createIcon(Perks.Perks[perkArray[i]]['Name'], Perks.Perks[perkArray[i]]['Desc'], Perks.Perks[perkArray[i]]['Type'], perkArray[i])

func _process(_delta):
	if hovered == true: _is_Button_Hovered()

func _is_Button_Hovered():
	if $MainWindow/Resume.is_hovered(): $MainWindow/Resume.modulate = Color(1, 1, 1)
	else: $MainWindow/Resume.modulate = Color(1, 1, 1)
	
	if $MainWindow/HTP.is_hovered(): $MainWindow/HTP.modulate = Color(1, 1, 1)
	else: $MainWindow/HTP.modulate = Color(1, 1, 1)
	
	if $"MainWindow/Main Menu".is_hovered(): $"MainWindow/Main Menu".modulate = Color(1, 1, 1)
	else: $"MainWindow/Main Menu".modulate = Color(1, 1, 1)
	
	if $MainWindow/Quit.is_hovered(): $MainWindow/Quit.modulate = Color(1, 1, 1)
	else: $MainWindow/Quit.modulate = Color(1, 1, 1)
#===============================================================================
### PAUSE BUTTONS CORNER
#===============================================================================

func _on_Resume_pressed():
	$MainWindow/Resume.pressed = false
	Input.action_press("ui_cancel")

func _on_Main_Menu_pressed():
	if get_tree().change_scene('res://UI/MainMenu.tscn') != OK: Glob.Log('Can\'t change scene in ' + name)

func _on_Quit_pressed():
	get_tree().quit()

func openPauseMenu():
	visible = true

func closePauseMenu():
	visible = false

func _on_HTP_pressed():
	$MainWindow/HTP.pressed = false
	$"..".open('HTP')
	$".".visible = false
