extends Node
################################################################################
# NOTES FOR COMPANION MANAGER
#	CompMan uses .format({_}) to load in variables, therefore in the string, you
#	must denote the variable using {_} (like {name}, {skill}
#	Currently supported string variables:
#		{name}, {Name} - Randomized moniker for player.
#		{skill} - One of the 4 hotkeyed skill names or "your head" if no skill
#		{attack} - assigned by event (before getObjectiveText.)
#		{enemy} {Enemy} - current name of the enemy in the level
################################################################################
var formatted:String = '' #temp used for formatting the text with variables
var prevTxt:String = '' #For checking an already said thing

onready var CQ = []#[$'../GameManager/Tier1/ConquestPanel', $'../GameManager/Tier2/ConquestPanel', $'../GameManager/BossArena/BossPanel']
onready var hud = get_node(Glob.HUD)
onready var EMan = get_node(Glob.EMan)
onready var objectives:Array = []
var idling:bool = true

export(String) var enemyName:String = "that asshole"
export(PoolStringArray) var ExtraLore:PoolStringArray = PoolStringArray([])

var Monikers:Array = ['Chief', 'mi amor', 'Commander', 'GG', 'Rockstar']
var currentMoniker:String = "Shitface"
var targetedSkill:String = "your head"

# Signal based
var Launched = PoolStringArray([
	'Good luck, {name}',
	"Go get 'em!",
	"Let's do this!",
	"Let's have some fun."])
var Objective=PoolStringArray([
	"Try to {objective}.",
	"I think we should {objective}.",
	"Perhaps if we {objective}, thing's might work out.",
	"{Name}, {objective}.",
	"You need to {objective}, {name}.",
	"Let's {objective}"])
var Enemy=PoolStringArray([
	"{Name}! {Enemy} is {attack}!",
	"{enemy} is {attack}!",
	"I think {enemy} is {attack}",
	"Look out, {name}! The enemy is {attack}!",
	"It's {attack}!"])
var Idle = PoolStringArray([
	"All systems are go, {name}",
	"We are ready to assault, {name}",
	"Waiting for orders.",
	"Don't be shy, get right in there!",
	"Battle stations ready!",
	"{Name}, the system is ready when you are."])
var PostConquest = PoolStringArray([
	"Let's get that Servo unlocked.",
	"There must be a way to the next tier.",
	"Perhaps we should unlock that Servo, {name}",
	"{Enemy} must have a way to unlock the Servo"])
var Winning = PoolStringArray([
	"They don't stand a chance!",
	"Our mission is almost complete.",
	"Just a bit more to go, {name}",
	"The Morning Star never stood a chance!"
	])
var Neutral = PoolStringArray([
	"We can't stop now, have at them, {name}!",
	"Don't forget to use {skill}!",
	"{skill} would be really useful right now.",
	"They don't stand a chance against our might!"
	])
var Losing = PoolStringArray([
	"This is reminding me of Operation Mentakis...",
	"This isn't looking good.",
	"Careful, {name}. We aren't doing so well.",
	"Quick, use {skill} to get out of this mess!",
	"This will not be the end for us!",
	"Humanity is depending on us, {name}."
	])
var TierVictory = PoolStringArray([
	"Well done, {name}. Just a bit more to go.",
	"Excellent work, {name}. Nothing can stop you now!",
	"{Enemy} can't keep us down!",
	"We're coming for you, {enemy}!",
	"Can't stop us now, {enemy}!"])
var BossVictory = PoolStringArray([
	"Hah! {Enemy} never stood a chance.",
	"Typical day in the life of the rebellion!",
	"{Enemy} is defeated, well done {name}",
	"You're welcome, {name}."])
var LostBall = PoolStringArray([
	"Don't worry, we'll get 'em next time...",
	"Ouch, that's got to hurt.",
	"Don't let it get you down, {name}",
	"We can still do this! Next time {enemy} won't stand a chance.",
	"{Name}...",
	"{Name}!",
	"..."])
var SavedBall = PoolStringArray([
	"Not this time! I've got you, {name}.",
	"{Enemy} thought it could sink us? Think again!",
	"Not the first time I've saved your ass! Right, {name}?"])

func _ready() -> void:
	$IdleTimer.wait_time = TAU
	if !ExtraLore.empty():
		Idle.append_array(ExtraLore)
		Winning.append_array(ExtraLore)
		Neutral.append_array(ExtraLore)
		Losing.append_array(ExtraLore)
		PostConquest.append_array(ExtraLore)
	yield($'../GameManager', 'ready')
	for i in $'../GameManager'.Tier.size():
		CQ.append($'../GameManager'.Tier[i].find_node("ConquestPanel"))

	yield(hud, 'ready')
	hud.updateCompanion(Idling())


func getText(from:PoolStringArray, customInput:String='') -> String:
	randomize()
	RandomizeMoniker()
	RandomizeSkill()
	formatted = from[randi() % from.size()]
	return formatted.format({
		"name":currentMoniker,
		"Name":currentMoniker.capitalize(),
		"skill":targetedSkill,
		"attack":customInput if customInput != '' else "performing shenanigans",
		"objective":customInput if customInput != '' else "do the thing",
		"enemy":enemyName,
		"Enemy":enemyName.capitalize()})
func Goal(currObj:String='') -> String: return getText(Objective, currObj)
func EnemyAttack(currAtt:String='') ->String: return getText(Enemy, currAtt)
func Idling() -> String: return getText(Idle)
func BallLaunched() -> String: return getText(Launched)
func BallSaved() -> String: return getText(SavedBall)
func BallLost() -> String: return getText(LostBall)
func TierGet() -> String: return getText(TierVictory)
func BossGet() -> String: return getText(BossVictory)
func getAction(val) -> String:
	if val <= 33: return getText(Losing)
	elif val > 33 and val < 66: return getText(Neutral)
	elif val >= 66: return getText(Winning)
	else: return "Oops, something went wrong with my brain..."
func RandomizeSkill() -> void:
	randomize()
	var i = randi() % 4
	targetedSkill = Glob.EquippedSkills[i].Name if Glob.EquippedSkills[i] != Glob.noSkill else "Your head"
func RandomizeMoniker() -> void:
	randomize()
	currentMoniker = Monikers[randi() % Monikers.size()]


func _on_IdleTimer_timeout() -> void:
	var text
	randomize()
	if idling:
		if CQ[$"../GameManager".currentTier-1].get_parent().phase == 2:
			text = getText(PostConquest)
			if text == prevTxt:
				randomize()
				text = getText(PostConquest)
		if !CQ[$"../GameManager".currentTier-1].get_parent().active:
			text = Idling()
			if text == prevTxt:
				randomize()
				text = Idling()
		else:
			text = getAction(CQ[$"../GameManager".currentTier-1].progress)
			if text == prevTxt:
				randomize()
				text = getAction(CQ[$"../GameManager".currentTier-1].progress)
		hud.updateCompanion(text)
		prevTxt = text
		hud.playCompAnim('Neutral')
		$IdleTimer.start(rand_range(TAU, TAU + TAU))
	if !idling:
		$IdleTimer.start(rand_range(TAU, TAU + TAU))
		idling = true

func event():
	match EMan.TYPE:
		"Area":
			area()
func area():
	match EMan.NAME:
		'BallLaunched':
			hud.updateCompanion(BallLaunched(), true)
			idling = false
			hud.playCompAnim("Neutral")
		'Death':
			if EMan.OTHER == 'Sink':
				hud.updateCompanion(BallSaved() if $'../GameManager'.ballSaverActive else BallLost(), true)
				hud.playCompAnim("Danger")
			if EMan.OTHER == 'Conquest':
				hud.updateCompanion(BallLost(), true)
				hud.playCompAnim("Danger")
			idling = false

func bossAttack(text:String):
	hud.updateCompanion(EnemyAttack(text), true)
	$IdleTimer.start(rand_range(TAU+PI, TAU+TAU))

func _on_ObjTimer_timeout() -> void:
	randomize()
	var activeObjectives = []
	$IdleTimer.start(rand_range(TAU+PI, TAU+TAU))
	for i in objectives.size():
		if objectives[i].active: activeObjectives.append(objectives[i].compText)
	if !activeObjectives.empty():
		hud.updateCompanion(Goal(activeObjectives[randi() % activeObjectives.size()]))
		hud.playCompAnim('Neutral')
	else: _on_IdleTimer_timeout()
