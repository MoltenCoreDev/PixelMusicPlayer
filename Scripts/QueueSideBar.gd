extends Panel

# ------------------------------------------------------------------------------
onready var List: VBoxContainer = $ScrollContainer/QueueList
onready var Entry: PackedScene = preload("res://Scenes/QueueEntry.tscn")
# ------------------------------------------------------------------------------

func _ready() -> void:
	Player.connect("queue_updated", self, "_update_list")

func _update_list() -> void:
	for entry in List.get_children():
		entry.queue_free()
	var i := 0
	for track in Player.queue:
		var entry := Entry.instance()
		entry.index = i
		entry.track = track
		List.add_child(entry)
		i += 1

# ------------------------------------------------------------------------------
