extends CanvasLayer

onready var label = $Text
var currentText = 0
var storyDone:bool = false

export(Array, String, MULTILINE) var StoryDialogue = [
	"It was the year 2093, and the panda crisis nearly drove mankind to the brink of extinction. \n Society is now but a shell of its former glory, yet its inhabitants live on. \n Corporations have taken over, inducing terror among  the populace as they strive for more power.",

	"Unable to stand for this atrocity, inhabitants Geronimo and Athena decide to rebel. \n They decide to sneak into a nearby Morning Star HQ, and gain access into its systems to free others.",
	"At your command, Captain. \n Establishing connection...",

	]

func _ready():
	get_tree().paused = true
	visible = true
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
		$"../CameraMan".PlayIntro()
		return
	label.percent_visible = 0
	label.text = StoryDialogue[currentText]


func _on_ButtonPrompt_pressed():
	SetText(currentText+1)
