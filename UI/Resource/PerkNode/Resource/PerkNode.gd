extends VBoxContainer

signal pressed

enum{UP,DOWN,PLUS,MINUS}
var Description:String = 'New Perk wow so cool'
var Name:String = 'The Thing'
var Img
var Key:String = 'FCBallsUP'
func _ready():
	if $PerkIcon.connect('pressed', self, 'pressed') != OK: Glob.Log("ConnectPressed Fail: " + name)

func createIcon(iName:String, desc:String, type:String, key:String):
	Name = iName
	Description = desc
	$PerkIcon.hint_tooltip = desc
	hint_tooltip = desc
	Key = key
	match type:
		'Plus':$PerkIcon.texture_normal = load('res://UI/Resource/PerkNode/Resource/Perk_Plus.png')
		'Minus':$PerkIcon.texture_normal = load('res://UI/Resource/PerkNode/Resource/Perk_Minus.png')
		'Up':$PerkIcon.texture_normal = load('res://UI/Resource/PerkNode/Resource/Perk_Up.png')
		'Down':$PerkIcon.texture_normal = load('res://UI/Resource/PerkNode/Resource/Perk_Down.png')
		'Unique':$PerkIcon.texture_normal = load('res://UI/Resource/PerkNode/Resource/Perk_Unique.png')
	Img = $PerkIcon.texture_normal
	$PerkName.text = Name if Name != '' else 'NameMissing'

func pressed(): #Forwarding button signal to VBox/Parent
	emit_signal('pressed')
