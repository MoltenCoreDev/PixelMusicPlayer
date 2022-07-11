extends Panel
# TODO: DOCS

# ------------------------------------------------------------------------------
onready var List: ItemList = $MainList
# ------------------------------------------------------------------------------

func _ready() -> void:
	Global.connect("library_path_changed", self, "_reimport_library")
	var dir := Directory.new()
	if dir.file_exists("user://Library.tres"):
		var lib := load("user://Library.tres")
		Global.library = lib
		_redraw_library()

# ------------------------------------------------------------------------------

func _redraw_library() -> void:
	List.clear()
	for track in Global.library.tracks:
		List.add_item(track.name)

func _reimport_library(files: Array) -> void:
	var lib := LibraryFile.new()
	var final_string := ""
	for item in files:
		var track := Track.new()
		track.path = item
		track.name = item.get_file()
		lib.tracks.append(track)
	ResourceSaver.save("user://Library.tres", lib)

# ------------------------------------------------------------------------------
