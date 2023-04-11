tool
extends Path2D

export(int, LAYERS_2D_PHYSICS) var CollisionLayer = 1
export(int, LAYERS_2D_PHYSICS) var CollisionMask = 1

enum{BUILD, NUKE} # Actions for function
const empty = []

var State = Glob.OCCUPIED setget setState
var sleeping = true setget setSleep

###Editor Settings
export(bool) var PathVisible = true setget path

###Command Options
export(int, "Select", "All", "Collision", "Poly", "Line") var ___Build___ = 0 setget buildThing
export(int, "Select", "All", "Collision", "Poly", "Line") var ___Nuke___ = 0 setget nukeThing
###Build Settings
export(int, 1, 360) var accuracy = 1
###MakeCircle
export(bool) var ___MakePoly___ = false setget makePoly
export(int) var radius = 16
export(int) var sides = 3 #triangle

func _ready() -> void:
	if !Engine.editor_hint:
		$Solid.collision_layer = CollisionLayer
		$Solid.collision_mask = CollisionMask
###===================================================================
### -------BUILD FUNCTIONS
###===================================================================
func collision(action):
	if Engine.editor_hint:
		if $Solid/Collision:
			$Solid/Collision.global_transform = global_transform
			if action == BUILD:
				var new = curve.tessellate(5, accuracy) #Because private Array BS
				if new.size() > 0: new.remove(new.size() - 1)
				$Solid/Collision.polygon = new
			if action == NUKE: $Solid/Collision.polygon = empty
		else: print("There is no Collision in Solid. Make sure the node is named Collision and has a polygon parameter")
	___Build___ = 0
	___Nuke___ = 0
func poly(action):
	if Engine.editor_hint:
		if $Poly:
			$Poly.global_transform = global_transform
			if action == BUILD:
				var new = curve.tessellate(5, accuracy) #Because private Array BS
				if new.size() > 0: new.remove(new.size() - 1)
				$Poly.polygon = new
			if action == NUKE: $Poly.polygon = empty
		else: print("There is no Poly child. Make sure the node is named Poly and has a polygon parameter")
	___Build___ = 0
	___Nuke___ = 0
func line(action):
	if Engine.editor_hint:
		if $Line:
			$Line.global_transform = global_transform
			if action == BUILD: $Line.points = curve.tessellate(5, accuracy)
			if action == NUKE: $Line.points = empty
		else: print("There is no Line child. Make sure the node is named Line and has a points parameter")
		___Build___ = 0
		___Nuke___ = 0

func makeCurve():
	if Engine.editor_hint:
		curve = Curve2D.new()
		var i = 0
		while(i < 360):
	#circle point = originX||Y + radius * sin(angle)X||cos(angle)Y
			curve.add_point(Vector2(radius * sin(deg2rad(i)), radius * cos(deg2rad(i))))
			i += (360 / sides)
		curve.add_point(curve.get_point_position(0))
		___MakePoly___ = false

###===================================================================
### -------SETGETS
###===================================================================
func buildThing(thing):
	if Engine.editor_hint:
		___Build___ = thing
		match thing:
			0:pass
			1:
				collision(BUILD)
				poly(BUILD)
				line(BUILD)
			2: collision(BUILD)
			3: poly(BUILD)
			4: line(BUILD)
func nukeThing(thing):
	if Engine.editor_hint:
		___Nuke___ = thing
		match thing:
			0:pass
			1:
				collision(NUKE)
				poly(NUKE)
				line(NUKE)
			2: collision(NUKE)
			3: poly(NUKE)
			4: line(NUKE)
func path(v):
	if Engine.editor_hint:
		PathVisible = v
		self_modulate.a = 1 if PathVisible else 0
func makePoly(v):
	if Engine.editor_hint:
		___MakePoly___ = v
		if ___MakePoly___: makeCurve()
func setSleep(v):
	sleeping = v
	$Solid.sleeping = sleeping
func setState(v):
	State = v
	$Line.light_mask = State
