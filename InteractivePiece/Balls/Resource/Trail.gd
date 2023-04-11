extends Line2D

export(NodePath) var targetPath
export var length = 10

var point = Vector2.ZERO

onready var target = get_node(targetPath)

func _physics_process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	point = target.global_position
	add_point(point)
	while get_point_count() > length:
		remove_point(0)
func removeAll():
	points = []
