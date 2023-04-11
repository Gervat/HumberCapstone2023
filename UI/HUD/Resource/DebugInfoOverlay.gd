extends CanvasLayer

var active:bool = false setget toggle

onready var values:Dictionary = {}

func createOverlay(title:String):
	#Create Title Label
	var titleCard = Label.new()
	titleCard.name = title
	titleCard.text = title
	$HBoxContainer/Titles.add_child(titleCard)
	titleCard.owner = $HBoxContainer/Titles
	#Create Value Label
	var valueCard = Label.new()
	valueCard.name = title
	$HBoxContainer/Values.add_child(valueCard)
	valueCard.owner = $HBoxContainer/Values
	values[title] = valueCard


func printv(valueName:String, withValue):
	values[valueName].text = str(withValue)

func toggle(v:bool):
	active = v
	visible = active
