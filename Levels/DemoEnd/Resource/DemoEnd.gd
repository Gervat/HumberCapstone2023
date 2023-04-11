extends Control

onready var hovered = true

func _process(_delta):
	if hovered == true: _is_Button_Hovered()

func _is_Button_Hovered():
	if $DemoEnd/DemoEnd_Return.is_hovered(): $DemoEnd/DemoEnd_Return.modulate = Color(0.06, 0.91, 0.91)
	else: $DemoEnd/DemoEnd_Return.modulate = Color(1, 1, 1)

func _on_DemoEnd_Return_pressed():
	if get_tree().change_scene("res://UI/MainMenu.tscn") != OK: print("Error with change_scene!")
