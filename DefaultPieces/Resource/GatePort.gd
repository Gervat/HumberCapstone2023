extends KinematicBody2D

#ON HOLD UNTIL FURTHER NOTICE
#export(int, "MASK", "BOOLEAN") var GATE_TYPE = 0

#Gate Variables global functionality
export var OPENED:bool = false setget switch
export var LOCKED:bool = false
export var LOCK_ON_OPEN:bool = true

#Mask unlock variables
export(int, LAYERS_3D_PHYSICS) var OPEN_CODE:int = 255
var codeTotal:int = 0
### UTILITY ----------------------------------------------------------
func switch(v:bool):
	if !LOCKED:
		if OPENED != v: $AnimationPlayer.play("Open") if v else $AnimationPlayer.play_backwards("Open")
		if v and LOCK_ON_OPEN: LOCKED = true
		OPENED = v
### SIGNALS ----------------------------------------------------------

func updateCode(codePos, on:bool) -> void:
	if !LOCKED:
		if on: codeTotal += codePos
		if !on: codeTotal -= codePos
		switch(codeTotal == OPEN_CODE)

#	match GATE_TYPE:
#		0:#MASK
#			#This assumes all buttons were off to begin with.
#			if button.isOn(): codeTotal += button.codePos
#			if !button.isOn(): codeTotal -= button.codePos
#			switch(codeTotal == OPEN_CODE)
#		2:#BOOLEAN
#			for i in B.size():
#				if B[i].currState == 2:
#					switch(true)
#					break
#				else: switch(false)
#		3: #SEQUENTIAL
#			#DO SEQUENCING CODE HERE
#			if sequence == sequenceCode: switch(true)
#			for i in B.size():
#				B[i].currState = LOCKED
