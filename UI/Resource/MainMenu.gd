extends Control

onready var scene:String
export(String) var LevelName = 'MainMenu'
onready var hovered = true
onready var ResolutionDropDown = $MainMenuManager/Graphics/Resolution/Resolutions
onready var ScreenModeDropDown = $"MainMenuManager/Graphics/Screen Mode/Screen Options"
onready var HTP_Sprite = $MainMenuManager/HowToPlay/IMG
onready var HTP_Title = $MainMenuManager/HowToPlay/IMG_Title

#AUDIO BUSES
var master_bus = AudioServer.get_bus_index("Master")
var se_bus = AudioServer.get_bus_index("SFX")
var dialogue_bus = AudioServer.get_bus_index("Dialogue")
var music_bus = AudioServer.get_bus_index("Music")

var base_master = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
var base_se = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
var base_dialogue = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogue"))
var base_music = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))

#HOW-TO-PLAY PRELOAD PICTURES
var currentSet = 0
var HTP_IMG = [
	load("res://UI/HUD/Resource/IMG/ControlsHTP.PNG"),
	load("res://UI/HUD/Resource/IMG/PlayerHUD_HTP.PNG"),
	]

func _ready():
	Level.currentScene = LevelName #<----------- must first know it's name

	$MainMenuManager/Options_Buttons.visible = false
	$MainMenuManager/Audio.visible = false
	$MainMenuManager/Graphics.visible = false
	$MainMenuManager/HowToPlay.visible = false
	$"MainMenuManager/Start Confirmation".visible = false
	$MainMenuManager/Main_Buttons.visible = true
	$MainMenuManager/Credits.visible = false

	add_items_Resolution()
	add_items_ScreenMode()

	#SET INITIAL GAME WINDOW SIZE ON GAME START
	_on_Resolutions_item_selected(0)
	_on_Screen_Options_item_selected(0)

	#SET INITIAL HOW-TO-PLAY TITLE AND IMAGE
	_HTPset(0)

func _process(_delta):
	if hovered == true: _is_Button_Hovered()

	$"MainMenuManager/Audio/Volume Control/Master/Master Slider #".text = str($"MainMenuManager/Audio/Volume Control/Master/Master Slider".value)
	$"MainMenuManager/Audio/Volume Control/Sound Effects/SE Slider #".text = str($"MainMenuManager/Audio/Volume Control/Sound Effects/SE Slider".value)
	$"MainMenuManager/Audio/Volume Control/Dialogue/Dialogue Slider #".text = str($"MainMenuManager/Audio/Volume Control/Dialogue/Dialogue Slider".value)
	$"MainMenuManager/Audio/Volume Control/Music/Music Slider #".text = str($"MainMenuManager/Audio/Volume Control/Music/Music Slider".value)

#===============================
### MAIN BUTTON EVENTS
#===============================
func _is_Button_Hovered():
	if $"MainMenuManager/Main_Buttons/Start Game".is_hovered(): $"MainMenuManager/Main_Buttons/Start Game/StartLabel".modulate = Color(0.06, 0.91, 0.91)
	else: $"MainMenuManager/Main_Buttons/Start Game/StartLabel".modulate = Color(1, 1, 1)

	if $MainMenuManager/Main_Buttons/HowToPlay.is_hovered(): $MainMenuManager/Main_Buttons/HowToPlay/HTPLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Main_Buttons/HowToPlay/HTPLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Main_Buttons/Options.is_hovered(): $MainMenuManager/Main_Buttons/Options/OptionsLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Main_Buttons/Options/OptionsLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Main_Buttons/Exit.is_hovered(): $MainMenuManager/Main_Buttons/Exit/ExitLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Main_Buttons/Exit/ExitLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Options_Buttons/Graphics.is_hovered(): $MainMenuManager/Options_Buttons/Graphics/GraphicsLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Options_Buttons/Graphics/GraphicsLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Options_Buttons/Audio.is_hovered(): $MainMenuManager/Options_Buttons/Audio/AudioLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Options_Buttons/Audio/AudioLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Options_Buttons/Credits.is_hovered(): $MainMenuManager/Options_Buttons/Credits/CreditsLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Options_Buttons/Credits/CreditsLabel.modulate = Color(1, 1, 1)

	if $MainMenuManager/Options_Buttons/Back.is_hovered(): $MainMenuManager/Options_Buttons/Back/BackLabel.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Options_Buttons/Back/BackLabel.modulate = Color(1, 1, 1)

	if $"MainMenuManager/Audio/Return Button".is_hovered(): $"MainMenuManager/Audio/Return Button".modulate = Color(0.06, 0.91, 0.91)
	else: $"MainMenuManager/Audio/Return Button".modulate = Color(1, 1, 1)

	if $"MainMenuManager/Graphics/GraphicsReturn Button".is_hovered(): $"MainMenuManager/Graphics/GraphicsReturn Button".modulate = Color(0.06, 0.91, 0.91)
	else: $"MainMenuManager/Graphics/GraphicsReturn Button".modulate = Color(1, 1, 1)

	if $"MainMenuManager/HowToPlay/HTP_Return Button".is_hovered(): $"MainMenuManager/HowToPlay/HTP_Return Button".modulate = Color(0.06, 0.91, 0.91)
	else: $"MainMenuManager/HowToPlay/HTP_Return Button".modulate = Color(1, 1, 1)

	if $"MainMenuManager/Start Confirmation/PlayButton".is_hovered(): $"MainMenuManager/Start Confirmation/PlayButton".modulate = Color(0.06, 0.91, 0.91)
	else: $"MainMenuManager/Start Confirmation/PlayButton".modulate = Color(1, 1, 1)

	if $MainMenuManager/Credits/Credits_Return.is_hovered(): $MainMenuManager/Credits/Credits_Return.modulate = Color(0.06, 0.91, 0.91)
	else: $MainMenuManager/Credits/Credits_Return.modulate = Color(1, 1, 1)

func _on_Start_Game_pressed():
	hovered = false
	$"MainMenuManager/Main_Buttons/Start Game/StartLabel".modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("PlayConfirm_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

func _on_HowToPlay_pressed():
	hovered = false
	$MainMenuManager/Main_Buttons/HowToPlay/HTPLabel.modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("HTP_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

func _on_Options_pressed():
	hovered = false
	$MainMenuManager/Main_Buttons/Options/OptionsLabel.modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("OptionButtons_FadeAway")
	hovered = true

func _on_Exit_pressed():
	hovered = false
	$MainMenuManager/Main_Buttons/Exit/ExitLabel.modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().quit()

#===============================
### OPTIONS BUTTON EVENTS
#===============================

func _on_Graphics_pressed():
	hovered = false
	$MainMenuManager/AnimationPlayer.play("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("Graphics_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

func _on_Audio_pressed():
	hovered = false
	$MainMenuManager/AnimationPlayer.play("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("Audio_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

func _on_Credits_pressed():
	hovered = false
	$MainMenuManager/AnimationPlayer.play("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("Credits_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true


func _on_Back_pressed():
	hovered = false
	$MainMenuManager/Options_Buttons/Back/BackLabel.modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

#===============================
### AUDIO BUTTON EVENTS
#===============================
func _on_Return_Button_pressed():
	hovered = false
	$"MainMenuManager/Audio/Return Button".modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("Audio_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	hovered = true

func _on_Master_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, base_master + value)
	AudioServer.set_bus_mute(0, (value == $'MainMenuManager/Audio/Volume Control/Master/Master Slider'.min_value))
func _on_SE_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(se_bus, base_se + value)
	AudioServer.set_bus_mute(1, (value == $'MainMenuManager/Audio/Volume Control/Sound Effects/SE Slider'.min_value))
func _on_Dialogue_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(dialogue_bus, base_dialogue + value)
	AudioServer.set_bus_mute(2, (value == $'MainMenuManager/Audio/Volume Control/Dialogue/Dialogue Slider'.min_value))
func _on_Music_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, base_music + value)
	AudioServer.set_bus_mute(3, (value == $'MainMenuManager/Audio/Volume Control/Music/Music Slider'.min_value))
#===============================
### GRAPHICS BUTTON EVENTS
#===============================

func _on_GraphicsReturn_Button_pressed():
	hovered = false
	$"MainMenuManager/Graphics/GraphicsReturn Button".modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("Graphics_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	hovered = true

func add_items_Resolution():
	ResolutionDropDown.add_item("1280 x 720")
	ResolutionDropDown.add_item("1024 x 546")
	ResolutionDropDown.add_item("1600 x 900")
	ResolutionDropDown.add_item("1920 x 1080")
	ResolutionDropDown.add_item("2k: 2560 x 1440")
	ResolutionDropDown.add_item("4k: 3840 x 2160")

func add_items_ScreenMode():
	ScreenModeDropDown.add_item("Windowed")
	ScreenModeDropDown.add_item("Borderless Fullscreen")
	ScreenModeDropDown.add_item("Fullscreen")

func _on_Resolutions_item_selected(index):
	var current_selected = index

	if current_selected == 0:
		OS.set_window_size(Vector2(1280, 720))

	if current_selected == 1:
		OS.set_window_size(Vector2(1024, 546))

	if current_selected == 2:
		OS.set_window_size(Vector2(1600, 900))

	if current_selected == 3:
		OS.set_window_size(Vector2(1920, 1080))

	if current_selected == 4:
		OS.set_window_size(Vector2(2560, 1440))

	if current_selected == 5:
		OS.set_window_size(Vector2(3840, 2160))

func _on_Screen_Options_item_selected(index):
	var current_selected = index

	if current_selected == 0:
		$MainMenuManager/Graphics/Resolution/Resolutions.visible = true
		OS.window_borderless = false
		OS.window_maximized = false
		OS.window_fullscreen = false
		_on_Resolutions_item_selected(0)
		ResolutionDropDown.text = str("1280 x 720")

	if current_selected == 1:
		$MainMenuManager/Graphics/Resolution/Resolutions.visible = false
		OS.window_borderless = true
		OS.window_maximized = true
		OS.window_fullscreen = false

	if current_selected == 2:
		$MainMenuManager/Graphics/Resolution/Resolutions.visible = false
		OS.window_fullscreen = true

#===============================
### HOW-TO-PLAY BUTTON EVENTS
#===============================
func _HTPset(val):
	currentSet = wrapi(val, 0, 2)

	if currentSet == 0:
		HTP_Sprite.texture = HTP_IMG[0]
		HTP_Title.text = ('PLAYERCONTROLS')
	if currentSet == 1:
		HTP_Sprite.texture = HTP_IMG[1]
		HTP_Title.text = ('PLAYERHUD')

func _on_LeftButton_pressed():
	_HTPset(currentSet-1)

func _on_RightButton_pressed():
	_HTPset(currentSet+1)

func _on_HTP_IMG_Button_toggled(button_pressed):
	if button_pressed:
		HTP_Enlarge()
	else:
		HTP_Original()

func HTP_Enlarge():
	$MainMenuManager/HowToPlay/AnimationPlayer.play("HTP_IMG_Enlarge")
	yield(get_tree().create_timer(0.5), "timeout")

func HTP_Original():
	$MainMenuManager/HowToPlay/AnimationPlayer.play_backwards("HTP_IMG_Enlarge")
	yield(get_tree().create_timer(0.5), "timeout")

func _on_HTP_Return_Button_pressed():
	hovered = false
	$"MainMenuManager/HowToPlay/HTP_Return Button".modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("HTP_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("MainButtons_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	hovered = true

#===============================
### PLAY CONFIRMATION BUTTON EVENTS
#===============================

func _on_PlayButton_pressed():

	hovered = false
	$"MainMenuManager/Start Confirmation/PlayButton".modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("PlayConfirm_FadeAway")
	yield(get_tree().create_timer(0.5),"timeout")
	hovered = true

	scene= Level.Next[Level.currentScene]
	if get_tree().change_scene(scene) != OK: prints("Error with change_scene()!", get_tree().change_scene(scene))

#===============================
### CREDITS BUTTON EVENTS
#===============================

func _on_Credits_Return_pressed():
	hovered = false
	$MainMenuManager/Credits/Credits_Return.modulate = Color(0, 0, 0)
	$MainMenuManager/AnimationPlayer.play("Credits_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	$MainMenuManager/AnimationPlayer.play_backwards("OptionButtons_FadeAway")
	yield(get_tree().create_timer(0.5), "timeout")
	hovered = true

