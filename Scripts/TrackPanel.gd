extends Panel

onready var Group: PackedScene = preload("res://Scenes/Group.tscn")
onready var List: VBoxContainer = $TrackPanelScroll/GroupList

func view_album(album_title: String, tracks: Array) -> void:
	_clear()
	var list_item := Group.instance()
	list_item.init(album_title, tracks)
	List.add_child(list_item)

func _clear() -> void:
	var children := List.get_children()
	for child in children:
		child.queue_free()
