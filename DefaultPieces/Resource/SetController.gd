extends Node

enum{PIECE, BUTTON, LIGHT}
export(int, 'Piece', 'Button', 'Light') var type = PIECE
export(bool) var shiftable = true

export(Array, NodePath) var Objects = []
var obj = []

var totalActive:int = 0
export(int, LAYERS_3D_PHYSICS) var unlockCode
export(Array, NodePath) var Doors
var totalCode:int = 0
var open = false
signal SetTrigger(type, name, tier)

func reset():
	for i in obj.size():
		obj[i].set_meta('active', false)

func _ready() -> void:
	if Objects.empty():
		return
	obj.resize(Objects.size())
	for i in obj.size():
		obj[i] = get_node(Objects[i])
		obj[i].set_meta('active', false)
		obj[i].set_meta('codePos', 1 << i)
		if type == PIECE or BUTTON:
			obj[i].trackHits = true
			obj[i].connect('Hit', self, 'pieceHit')
	if !Doors.empty():
		for i in Doors.size():
			Doors[i] = get_node(Doors[i])
			Doors[i].open = open
func _process(_delta: float) -> void:
	if !shiftable:
		return
	if Input.is_action_just_pressed('LeftFlipper'):
		rotate(true)
	if Input.is_action_just_pressed('RightFlipper'):
		rotate()

func rotate(left:bool=false):
	if obj.size() <= 1: return
	var temp = obj[0].get_meta('active') if left else obj[obj.size()-1].get_meta('active')
	if !left: ### ROTATE RIGHT
		var i = obj.size()-1
		while i >= 0:
			obj[i].set_meta('active', obj[i-1].get_meta('active') if i != 0 else temp)
			i -= 1
	elif left: ### ROTATE LEFT
		for i in obj.size():
			obj[i].set_meta('active', temp if i == obj.size() - 1 else obj[i+1].get_meta('active'))
	checkStates()

func checkStates():
	totalActive = 0
	totalCode = 0
	for i in obj.size():
		if obj[i].get_meta('active'):
			totalCode += obj[i].get_meta('codePos')
			totalActive += 1
	if totalCode == unlockCode:
		open = true
		emit_signal('SetTrigger', 'Unlocked', self, $'../..'.tierNum)
	elif totalActive == obj.size():
		open = true
		emit_signal('SetTrigger', 'Complete', self, $'../..'.tierNum)
	else: if open:
		open = false
		emit_signal('SetTrigger', 'Closed', self, $'../..'.tierNum)
	if !Doors.empty():
		for i in Doors.size():
			Doors[i].open = open

	if type == PIECE:
		for i in obj.size():
			if obj[i].get_meta('active'):
				obj[i].changeState(1024, false)
			else: obj[i].changeState($'../..'.State, false)

func pieceHit(object, _tier):
	for i in obj.size():
		if obj[i] == object: obj[i].set_meta('active', !obj[i].get_meta('active'))
	checkStates()
