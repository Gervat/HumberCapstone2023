extends Node2D

onready var WestBatteries = $PistonsWest.batteries
onready var MidBatteries = $PistonsMid.batteries
onready var EastBatteries = $PistonsEast.batteries
onready var AllBatteries:Array

var begin:bool = true

func _ready() -> void:
	AllBatteries.append_array(WestBatteries)
	AllBatteries.append_array(MidBatteries)
	AllBatteries.append_array(EastBatteries)
	$PistonsWest.connect('damaged', self, 'checkAll')
	$PistonsWest.connect('damaged', self, 'damage')
	$PistonsWest.connect('overload', self, 'checkAll')
	$PistonsWest.connect('overload', self, 'overloaded')
	$PistonsMid.connect('damaged', self, 'checkAll')
	$PistonsMid.connect('damaged', self, 'damage')
	$PistonsMid.connect('overload', self, 'checkAll')
	$PistonsMid.connect('overload', self, 'overloaded')
	$PistonsEast.connect('damaged', self, 'checkAll')
	$PistonsEast.connect('damaged', self, 'damage')
	$PistonsEast.connect('overload', self, 'checkAll')
	$PistonsEast.connect('overload', self, 'overloaded')


func _on_Idler_timeout() -> void:
	reroll()

func reroll():
	for i in AllBatteries.size():
		if AllBatteries[i].enemy: AllBatteries[i].enemy = false
		if AllBatteries[i].shown:  AllBatteries[i].shown = false

	var actives:Array = []
	actives.resize(7)
	var enemies:int = randi() % 6

	var availableBatts:Array = []
	availableBatts.append_array(AllBatteries)

	for i in actives.size():
		randomize()
		var j = randi() % availableBatts.size()
		actives[i] = availableBatts[j]
		availableBatts.remove(j)
		actives[i].shown = true
	for i in enemies:
		actives[i].enemy = true

func checkAll():
	var shown:int = 0
	for i in AllBatteries.size():
		if AllBatteries[i].shown and !AllBatteries[i].enemy:
			shown += 1
	print('Amount Shown: ', shown)
	if shown <= 0:
		begin = false
		$Idler.start()
		reroll()

func damage():
	$'../ConquestPanel'.updateBar(1 if begin else 7)
func overloaded():
	$'../ConquestPanel'.updateBar(-5)

