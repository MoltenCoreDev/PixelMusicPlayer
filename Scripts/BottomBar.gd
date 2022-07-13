extends Panel

# ------------------------------------------------------------------------------
onready var PlayPause: ToolButton = $MainControls/PlayPause
onready var MainPlayer: AudioStreamPlayer = Global.main.find_node("MainPlayer")
onready var VolumeSlider: HSlider = $VolumeSlider
# ------------------------------------------------------------------------------
onready var PlayIcon: Texture = preload("res://Assets/MainControls/play.png")
onready var PauseIcon: Texture = preload("res://Assets/MainControls/pause.png")
# ------------------------------------------------------------------------------

func _ready() -> void:
	Player.connect("playback_started", self, "_update_progress")

# ------------------------------------------------------------------------------

func _update_progress() -> void:
	ProgressBar.max_value = Player._get_duration()

func _on_PlayPause_pressed() -> void:
	if Player.toggle_pause() == true:
		PlayPause.icon = PlayIcon
	else:
		PlayPause.icon = PauseIcon
# ------------------------------------------------------------------------------

func _on_VolumeSlider_value_changed(value) -> void:
	MainPlayer.volume_db = value
	
# ------------------------------------------------------------------------------

func _on_Queue_pressed():
	$Queue/QueuePanel.visible = !$Queue/QueuePanel.visible


func _on_Forward_pressed():
	Player.skip()
