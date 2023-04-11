extends Sprite

func queue(anim:String):
	$AnimationPlayer.queue(anim)
func play(anim:String):
	$AnimationPlayer.play(anim)
func play_backwards(anim:String):
	$AnimationPlayer.play_backwards(anim)
func stop():
	$AnimationPlayer.stop()
