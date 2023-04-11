extends Polygon2D
var out:bool = false

func _ready() -> void:
	randomize()
	$AnimationPlayer.play('Spin')
	#$AnimationPlayer.play('Spin',-1,rand_range(0.9, 1.1))
	$Tween.interpolate_property(self, 'scale', 0.75, 1, 1)
	$Tween.start()
	pulse()

func pulse():
	yield($Tween,'tween_completed')
	if out:
		$Tween.interpolate_property(self, 'scale', Vector2(0.75, 0.75), Vector2.ONE, 1)
		out = false
	else:
		$Tween.interpolate_property(self, 'scale', Vector2.ONE, Vector2(0.75, 0.75), 1)
		out = true
	$Tween.start()
	pulse()

