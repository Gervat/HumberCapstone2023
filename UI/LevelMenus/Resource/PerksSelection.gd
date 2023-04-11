extends Node2D

onready var PerkNodes = $Perks.get_children()
#Array of keys (['FCBallsUP'], ['FCDurationUP'], etc)
var perkNames:Array = Perks.Perks.keys()
var index = 0

var WhichLevel = 0
var scene:String
#===============================================================================
### PERK BUTTONS CORNER
#===============================================================================
func _ready():
	for i in PerkNodes.size():
		spawnIcon(i)
		PerkNodes[i].connect('pressed', self, '_on_Perk_pressed', [i])
	#more random stuff here

func _on_Perk_pressed(idx:int):
	$PerkSide/PerkImage.set_texture(PerkNodes[idx].Img)
	$PerkSide/PerkName.set_text(PerkNodes[idx].Name)
	$PerkSide/PerkDescription.set_text(PerkNodes[idx].Description)
	index = idx

func spawnIcon(i:int):
	randomize() #randomize internal seed
	var r:int = randi() % perkNames.size()
	var targetedPerk = Perks.Perks[perkNames[r]]

	PerkNodes[i].createIcon(targetedPerk['Name'], targetedPerk['Desc'], targetedPerk['Type'], perkNames[r])
	perkNames.remove(r)

func _on_SelectButton_pressed():
	Perks.activatePerk(PerkNodes[index].Key)
	closePerkSelection()
	get_tree().paused = false
	yield(get_tree().create_timer(0.5), "timeout")
	if get_tree().change_scene(scene) != OK: prints("Error with change_scene()!", get_tree().change_scene(scene))

func openPerkSelection():
	$AnimationPlayer.play_backwards("Perk_Fade")
	yield(get_tree().create_timer(0.5), "timeout")

func closePerkSelection():
	$AnimationPlayer.play("Perk_Fade")
