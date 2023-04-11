extends Node2D

export var compText:String = "doing this"
export var hitsRequired:int = 3
export(Array, NodePath) var Obj = []
export var damage:float = 100.00

signal objectiveComplete(name, obj)
var Reticle = preload('res://Administration/Objectives/Resource/HitReticle.tscn')
var Waypoint = preload('res://Administration/Objectives/Resource/Waypoint.tscn')
var active:bool = false setget activate
var complete:bool = false setget completed
onready var tier:int = $"../..".tierNum

onready var reticles = []
onready var waypoints = []
onready var EMan = get_node(Glob.EMan)
onready var screenArea = $Screen/Area
var totalCompleted:int = 0

func _ready():
	if connect('objectiveComplete', EMan, 'objective') != OK: Glob.Log("ConnectObjective Fail: " + name)
	if Obj.empty(): return
	for i in Obj.size():
		Obj[i] = get_node(Obj[i])
		addReticle(i)
		if Obj[i].has_signal("Hit"):
			Obj[i].trackHits = true
			Obj[i].connect("Hit", self, "objectiveHit")
	$'../../../../CompMan'.objectives.append(self)
func objectiveHit(obj, _tier):
	if !active:return
	for i in Obj.size():
		if Obj[i] == obj and obj.hits >= hitsRequired:
			obj.trackHits = false
			### This line is a BUG WORKAROUND
			reticles[i].visible = false
			totalCompleted += 1
	if totalCompleted == Obj.size(): completed(true)
func completed(v):
	if !active: return
	complete = v
	activate(false)
	EMan.addDamage(damage)
	if v: emit_signal('objectiveComplete', name, self)

func addReticle(i):
	var ret = Reticle.instance()
	add_child(ret)
	ret.owner = self
	ret.global_position = Obj[i].global_position
	ret.z_index = Obj[i].z_index - 1
	ret.visible = active
	addWaypoint(ret)
	reticles.push_back(ret)

func addWaypoint(ref):
	if !is_inside_tree(): return
	var newWay = Waypoint.instance()
	screenArea.add_child(newWay)
	newWay.owner = screenArea
	newWay.ref = ref
	newWay.visible = active
	waypoints.push_back(newWay)

func reset():
	totalCompleted = false
	activate(false)
	for i in Obj.size():
		Obj[i].hits = 0
		Obj[i].trackHits = true
		reticles[i].visible = true

func activate(v):
	active = v
	visible = v
	for i in waypoints.size():
		waypoints[i].visible = v
		reticles[i].visible = v
