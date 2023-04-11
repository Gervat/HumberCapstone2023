extends Node

onready var EMan = get_node(Glob.EMan)

onready var TierSpawns:Array = [] #= [$'../Tier1/SpawnPoints'.get_children(), $'../Tier2/SpawnPoints'.get_children(), $'../BossArena/SpawnPoints'.get_children()]
onready var bug = $BugTimer
var FusterCluckBall = preload('res://InteractivePiece/Balls/FusterCluck.tscn')

var fusterClucks = []

func _ready() -> void:
	yield($'..', 'ready')
	for i in $'..'.Tier.size():
		TierSpawns.append($'..'.Tier[i].find_node("SpawnPoints").get_children())

###=============================================================================
### MAIN FUNCTIONS
###=============================================================================
func moveBall(to="LauncherSpawn", atTier=1): ##giving '' will move OOB
	if to != '': $PlayerBall.moveTo(getSpawnPos(to, atTier))
	elif to == '': $PlayerBall.moveTo(Vector2(9001, 1337))
	else:
		$PlayerBall.moveTo(getSpawnPos("LauncherSpawn", atTier))
func fusterCluck(active:bool):
	bug.start(Glob.fusterCluck['Duration']*2.0)
	var radius = 3
	var x = 0
	if active:
		fusterClucks.clear()
		for i in Glob.fusterCluck.Amount:
			fusterClucks.push_back(FusterCluckBall.instance())
			$Special.add_child(fusterClucks[i])
			fusterClucks[i].add_to_group("Ball")
			fusterClucks[i].global_position = Vector2($PlayerBall.global_position.x + radius * sin(deg2rad(x)), $PlayerBall.global_position.y + radius * cos(deg2rad(x)))
			fusterClucks[i].apply_impulse(Vector2.ZERO, $PlayerBall.global_position.direction_to(fusterClucks[i].global_position) * Glob.fusterCluck.Explosiveness)
			x += 360 / Glob.fusterCluck.Amount
			fusterClucks[i].collision_mask = $PlayerBall.collision_mask
			fusterClucks[i].collision_layer = $PlayerBall.collision_layer
			if fusterClucks[i].connect('damage', $'../../EventManager', 'addDamage') != OK: print('fusterCluck did not connect damage')
	if !active and !$Special.get_children().empty():
		for i in fusterClucks.size():
			if fusterClucks[i]: fusterClucks[i].die()
###===================================================================
###-------UTILITY FUNCTIONS-------
###===================================================================
func getSpawnPos(spawnName, desiredTier=1) -> Vector2:
	var targetPos = null
	for i in TierSpawns[desiredTier - 1].size():
		if spawnName in TierSpawns[desiredTier - 1][i].name:
			targetPos = TierSpawns[desiredTier - 1][i].global_position
	if !targetPos:
		targetPos = $Spawns/Tier1/LauncherSpawn.global_position
	return targetPos
func getPlayerPos() -> Vector2:
	if $PlayerBall: return $PlayerBall.global_position
	else: return getSpawnPos('LeftFlipperSpawn', 1)
func _on_BugTimer_timeout() -> void:
	if !$Special.get_children().empty():
		for i in $Special.get_child_count():
			$Special.get_child(i).queue_free()
