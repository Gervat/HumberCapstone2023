extends Area2D

export var AreaHold:bool = false
export var compText:String = "doing this"
export(Array, NodePath) var Points = []
export(Array, NodePath) var Sets = []

signal objectiveComplete(name, obj)
var active:bool = false setget activate
var complete:bool = false setget completed
var totalCompleted:int = 0
var prevMask:int = 0

onready var tier:int = $"../..".tierNum
onready var reticles = []
onready var waypoints = []
onready var EMan = get_node(Glob.EMan)
onready var screenArea = $Screen/Area

var Waypoint = preload('res://Administration/Objectives/Resource/Waypoint.tscn')

func _ready():
	if connect('objectiveComplete', EMan, 'objective') != OK: Glob.Log("ConnectObjective Fail: " + name)
	$'../../../../CompMan'.objectives.append(self)
	if Points.empty(): return
	for i in Points.size():
		Points[i] = get_node(Points[i])
		addWaypoint(Points[i])
		Points[i].visible = false
	if !Sets.empty():
		for i in Sets.size():
			Sets[i] = get_node(Sets[i])
			Sets[i].connect('SetTrigger', self, 'setTriggered')
	activate(false)

func setTriggered(type, set, _stier):
	if !active: return
	match type:
		'Unlocked':
			totalCompleted += 1
			for i in Sets.size():
				if Sets[i].name == set.name:
					Points[i].visible = false
		'Closed':
			totalCompleted -= 1
			for i in Sets.size():
				if Sets[i].name == set.name:
					Points[i].visible = true

	completed(totalCompleted == Sets.size())

func completed(v):
	if !active: return
	complete = v
	activate(!v)
	if v: emit_signal('objectiveComplete', name, self)

func addWaypoint(ref):
	if !is_inside_tree(): return
	var newWay = Waypoint.instance()
	screenArea.add_child(newWay)
	newWay.owner = screenArea
	newWay.ref = ref
	waypoints.push_back(newWay)

func reset():
	totalCompleted = 0
	activate(false)

func activate(v):
	active = v
	visible = v
	for i in Points.size():
		Points[i].visible = v

func _on_GoHere_body_entered(_body: Node) -> void:
	if !active:return
	if !AreaHold: completed(true)
	else:
		for i in Points.size():
			Points[i].visible = false

func _on_GoHere_body_exited(_body: Node) -> void:
	if !active:return
	if AreaHold: activate(true)
	else:
		for i in Points.size():
			Points[i].visible = true
