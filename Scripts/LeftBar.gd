extends Panel
# TODO: DOCS

# ------------------------------------------------------------------------------
onready var LeftBarEntry: PackedScene = preload("res://Scenes/LeftBarEntry.tscn")
onready var List: VBoxContainer = $ListScrollContainer/MainList
onready var TrackPanel: Panel = Global.main.find_node("TrackPanel")
# ------------------------------------------------------------------------------

func _ready() -> void:
	Global.connect("library_path_changed", self, "_reimport_library")
	var dir := Directory.new()
	if dir.file_exists("user://Library.tres"):
		var lib := load("user://Library.tres")
		Global.library = lib
		group_by_album()

# ------------------------------------------------------------------------------

# TODO sorting

# ------------------------------------------------------------------------------

func _clear() -> void:
	var items := List.get_children()
	for item in items:
		item.queue_free()
	if not Global.library:
		print("can't find library")
		return

func group_by_album() -> void:
	_clear()
	for album in Global.library.albums:
		var list_item := LeftBarEntry.instance()
		list_item.album_title = album
		list_item.tracks = Global.library.albums[album]
		List.add_child(list_item)

func _reimport_library(files: Array) -> void:
	var lib := LibraryFile.new()
	for path in files:
		if not path.ends_with(".mp3"):
			continue
		var track := TrackFile.new()
		# parse track
		track = Tag.read_ID3(path)
		if track.title == "":
			print("failed to parse tags, falling back to %s" % path)
			track.title = path
		lib.tracks.append(track)
	Global.library = lib
	ResourceSaver.save("user://Library.tres", lib)
	_get_albums()
	group_by_album()

func _get_albums() -> void:
	var lib := Global.library
	var albums = {}
	for track in lib.tracks:
		if track.album == "":
			continue
		
		if albums.keys().has(track.album):
			albums[track.album].append(track)
		else:
			albums[track.album] = []
			albums[track.album].append(track)
	lib.albums = albums
	Global.library = lib
	ResourceSaver.save("user://Library.tres", lib)
	

# ------------------------------------------------------------------------------

func _on_GroupAlbum_pressed():
	_clear()
	group_by_album()

# ------------------------------------------------------------------------------


