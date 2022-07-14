extends Panel

onready var List: VBoxContainer = $TrackPanelScroll/GroupList
onready var Entry: PackedScene = load("res://Scenes/TrackPanelEntry.tscn")
func view_album(album_title: String, tracks: Array) -> void:
	_clear()
	for track in tracks:
		var entry := Entry.instance()
		entry.track = track
		List.add_child(entry)

func _clear() -> void:
	var children := List.get_children()
	for child in children:
		child.queue_free()
