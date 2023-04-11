extends Node2D

export(float) var floorHeight = 0.3
export(int, LAYERS_2D_PHYSICS) var mask = 2


var State = Glob.OCCUPIED setget setState

func _ready() -> void:
	$Floor.collision_mask = 0

func _on_Doors_body_entered(body: Node) -> void:
	if !body.is_in_group("Ball"):return
	body.z_index = z_index
	body.collision_layer = mask + 4
	#if body.has("size"):
	$Tween.interpolate_property(body, "size", 1, 1.1, floorHeight)
	$Tween.start()
	$Floor.collision_mask = mask
	$Doors.collision_mask = 0

func _on_Floor_body_exited(body: Node) -> void:
	if !body.is_in_group("Ball"):return
	body.z_index = 0
	#if body.has("size"):
	$Tween.interpolate_property(body, "size", 1.1, 1, floorHeight)
	$Tween.start()
	body.collision_layer = 5
	$Floor.collision_mask = 0
	$Doors.collision_mask = 1

func setState(v):
	State = v
