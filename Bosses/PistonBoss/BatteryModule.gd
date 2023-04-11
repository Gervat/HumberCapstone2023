extends StaticBody2D

var tierNum:int = 8 #to quiet the battery

var shown:bool = false setget switch
var enemy:bool setget enemize

signal damaged
signal overload

onready var battery = $Arm/Bumper
onready var anim = $AnimationPlayer

func _ready() -> void:
	battery.trackHits = true
	battery.bumpSample = load('res://Bosses/PistonBoss/flaunch.wav')
	if battery.connect('Hit', self, 'batteryHit') != OK: Glob.Log('ConnectHit Fail: ' + name)

func batteryHit(_obj, _tierNum):
	switch(false)
	if enemy: emit_signal('overload')
	else: emit_signal('damaged')

### SETGETS

func enemize(v):
	enemy = v
	battery.Lethal = enemy
	battery.State = Glob.ENEMY if v else Glob.OCCUPIED

func switch(v):
	shown = v
	if v: anim.play('Open')
	if !v:
		anim.play('Close')
