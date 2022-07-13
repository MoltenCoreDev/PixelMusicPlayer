extends Panel

# ------------------------------------------------------------------------------
onready var PlayPause: ToolButton = $MainControls/PlayPause
onready var MainPlayer: AudioStreamPlayer = Global.main.find_node("MainPlayer")
onready var VolumeSlider: HSlider = $VolumeSlider
onready var DurationBar: HSlider = $DurationBar
# ------------------------------------------------------------------------------
onready var PlayIcon: Texture = preload("res://Assets/MainControls/play.png")
onready var PauseIcon: Texture = preload("res://Assets/MainControls/pause.png")
# ------------------------------------------------------------------------------
var thread: Thread
# ------------------------------------------------------------------------------

func _ready() -> void:
	thread = Thread.new()
	thread.start(self, "_position_updater")
	Player.connect("playback_started", self, "_update_progress")
	Player.connect("playback_started", self, "_update_playpause_icon")
	Player.connect("pause_changed", self, "_update_playpause_icon")

func _exit_tree():
	thread.wait_to_finish()

# ------------------------------------------------------------------------------

func _update_progress() -> void:
	DurationBar.max_value = Player._get_duration()

func _position_updater():
	while true:
		DurationBar.value = Player._get_position()
		yield(get_tree().create_timer(1), "timeout")

func _update_playpause_icon() -> void:
	if Player.Player.stream_paused == true:
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


func _on_PlayPause_pressed():
	Player.toggle_pause()
