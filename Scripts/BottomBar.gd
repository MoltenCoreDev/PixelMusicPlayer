extends Panel

# ------------------------------------------------------------------------------
onready var PlayPause: ToolButton = $MainControls/PlayPause
onready var MainPlayer: AudioStreamPlayer = Global.main.find_node("MainPlayer")
onready var VolumeSlider: HSlider = $VolumeSlider
# ------------------------------------------------------------------------------
onready var PlayIcon: Texture = preload("res://Assets/MainControls/play.png")
onready var PauseIcon: Texture = preload("res://Assets/MainControls/pause.png")
# ------------------------------------------------------------------------------
func _on_PlayPause_pressed() -> void:
	if Player.toggle_pause() == true:
		PlayPause.icon = PlayIcon
	else:
		PlayPause.icon = PauseIcon

func _on_Forward_pressed():
	pass # Replace with function body.

func _on_Back_pressed():
	pass # Replace with function body.
# ------------------------------------------------------------------------------

func _on_VolumeSlider_value_changed(value) -> void:
	MainPlayer.volume_db = value
	
# ------------------------------------------------------------------------------

