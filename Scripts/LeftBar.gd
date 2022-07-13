extends Panel
# TODO: DOCS

# ------------------------------------------------------------------------------
onready var Track: PackedScene = preload("res://Scenes/Track.tscn")
onready var List: VBoxContainer = $ListScrollContainer/MainList
# ------------------------------------------------------------------------------

func _ready() -> void:
	Global.connect("library_path_changed", self, "_reimport_library")
	var dir := Directory.new()
	if dir.file_exists("user://Library.tres"):
		var lib := load("user://Library.tres")
		Global.library = lib
		_redraw_library()

# ------------------------------------------------------------------------------

# TODO sorting

# ------------------------------------------------------------------------------

func _redraw_library() -> void:
	var items := List.get_children()
	for item in items:
		item.queue_free()
	if not Global.library:
		# TODO create logger API
		print("can't find library")
		return
	for track in Global.library.tracks:
		var list_item := Track.instance()
		list_item.track = track
		List.add_child(list_item)
		

func _reimport_library(files: Array) -> void:
	var lib := LibraryFile.new()
	for item in files:
		if not item.ends_with(".mp3"):
			continue
		var track := Tag.read_ID3(item)
		if track.title == "":
			track.title = item.get_file()
		lib.tracks.append(track)
	ResourceSaver.save("user://Library.tres", lib)
	Global.library = lib
	_redraw_library()

# ------------------------------------------------------------------------------

func _on_Refresh_pressed():
	_redraw_library()

# ------------------------------------------------------------------------------
