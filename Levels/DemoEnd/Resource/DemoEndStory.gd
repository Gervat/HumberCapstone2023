extends CanvasLayer

onready var label = $Text
var currentText = 0
var storyDone:bool = false

export(Array, String, MULTILINE) var StoryDialogue = [
	"And so papa bear finished his jar of honey, his hunger satieted for another day.",

	"Until mama bear discovered papa bear ate it all to himself.",
	"How will she react? Find out on the next episode of.... Neon Impulse!",
	""
	]

func _ready():
	visible = true
	$SkipText.visible = false
	SetText(0)

func _process(delta):
	$Text.percent_visible += delta

	if storyDone == false:
		if Input.is_action_just_pressed("ui_cancel"):
			SetText(StoryDialogue.size())
			storyDone = true

		if Input.is_action_just_pressed("Pull"):
			SetText(currentText+1)

func SetText(val):
	currentText = val
	if currentText == StoryDialogue.size():
		visible = false
		storyDone = true
		return
	label.percent_visible = 0
	label.text = StoryDialogue[currentText]

func _on_ButtonPrompt_pressed():
	SetText(currentText+1)
