extends Node
# This is the main player API for the music player
# This script contains code for actually playing the music

# ------------------------------------------------------------------------------
onready var Player: AudioStreamPlayer = Global.main.find_node("MainPlayer")
onready var Viewer: RichTextLabel = Global.main.get_node("dirty queue shower")
# ------------------------------------------------------------------------------
var queue: Array = []

var loop: bool = false
var shuffle: bool = false

# ------------------------------------------------------------------------------
signal finished

# ------------------------------------------------------------------------------

func _ready():
	Player.connect("finished", self, "_finished")

# ------------------------------------------------------------------------------

func _add_to_queue(track: TrackFile) -> void:
	queue.append(track)
	if not Player.playing:
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


# Returns the new pause state
func toggle_pause() -> bool:
	Player.stream_paused = !Player.stream_paused
	return Player.stream_paused

# ------------------------------------------------------------------------------

func _finished() -> void:
	emit_signal("finished", queue[0])
	queue.pop_front()
	if queue.size() > 0:
		_play(queue[0].path)


