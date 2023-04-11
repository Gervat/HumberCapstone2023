extends Timer

#===============================================================================
# HOW-TO:
#		1. Create a poly2D (or anything with a lightmask and a color property, NOT
# a modulate).
#		2. Copy it X amount of times inside the node.
#		2a. Blink STARTS at top and rotates down sequentially
#		3. Adjust speed of base timer.
#		4. ???
#		5. PROFIT
export(Color) var Colour = Color(0.019608, 0.627451, 0.301961)

var currentLight:int = 0

onready var Lights = self.get_children()

func _ready() -> void:
	if connect('timeout', self, '_on_LightSpeed_timeout') != OK: Glob.Log("ConnectTimeout Fail: " + name)

func _on_LightSpeed_timeout() -> void:
	currentLight = wrapi(currentLight + 1, 0, Lights.size())
	Lights[currentLight].light_mask = 2
	Lights[currentLight-1].light_mask = 0
	Lights[currentLight].color = Colour
	Lights[currentLight-1].color = Color(0.333333, 0.333333, 0.333333)

