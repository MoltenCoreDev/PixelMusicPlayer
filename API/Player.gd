extends Node
# This is the main player API for the music player
# This script contains code for actually playing the music

# ------------------------------------------------------------------------------
onready var Player: AudioStreamPlayer = Global.main.find_node("MainPlayer")
onready var Forward: ToolButton = Global.main.find_node("Forward")
onready var Back: ToolButton = Global.main.find_node("Back")
# ------------------------------------------------------------------------------
var queue: Array = []
var history: Array = []

var loop: bool = false
var shuffle: bool = false

# ------------------------------------------------------------------------------
signal finished
signal queue_updated
signal pause_changed

# ------------------------------------------------------------------------------

func _ready():
	Player.connect("finished", self, "_finished")

# ------------------------------------------------------------------------------

func add_to_queue(track: TrackFile) -> void:
	queue.append(track)
	emit_signal("queue_updated")
	if not Player.playing:
		_play(queue[0].path)

# internal function please use "skip"
func _play_next() -> void:
	if queue.size() > 0:
		_play(queue[0].path)

func _play(file_path: String) -> void:
	var file := File.new()
	file.open(file_path, File.READ)
	var size := file.get_len()
	var bytes := file.get_buffer(size)
	
	var stream := AudioStreamMP3.new()
	stream.data = bytes
	Player.stream = stream
	Player.playing = true
	Player.pause_mode = false
	emit_signal("playback_started")

func _stop() -> void:
	Player.stream = null
	Player.playing = false

# Returns the new pause state
func toggle_pause() -> bool:
	Player.stream_paused = !Player.stream_paused
	emit_signal("pause_changed")
	return Player.stream_paused

func skip() -> void:
	queue.pop_front()
	emit_signal("queue_updated")
	_stop()
	_play_next()

func remove_from_queue(index: int) -> void:
	if index == 0:
		skip()
	else:
		queue.pop_at(index)
		emit_signal("queue_updated")

func _get_duration() -> float:
	if Player.stream != null:
		return Player.stream.get_length()
	return 0.0

func _get_position():
	return Player.get_playback_position()

func _seek(time: float) -> void:
	Player.seek(time)

# ------------------------------------------------------------------------------

func _finished() -> void:
	emit_signal("finished")
	skip()
