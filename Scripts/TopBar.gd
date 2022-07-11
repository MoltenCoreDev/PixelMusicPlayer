extends Panel
# TODO: DOCS

# ------------------------------------------------------------------------------
onready var file_menu: MenuButton = $Container/File
onready var file_dialog: FileDialog = Global.main.find_node("FileDialog")
# ------------------------------------------------------------------------------

func _ready() -> void:
	_setup_file_menu(file_menu)

# ------------------------------------------------------------------------------
# This section contains setup functions for the FILE menu

func _setup_file_menu(menu: MenuButton) -> void:
	var popup := menu.get_popup()
	var entries := [
		"Import Library"
	]
	
	var i := 0
	for item in entries:
		popup.add_item(item, i)
		i += 1
	popup.connect("id_pressed", self, "_file_menu_pressed")

func _file_menu_pressed(id: int) -> void:
	match id:
		0:
			import_library()

# ------------------------------------------------------------------------------
# This section contains utility functions for the FILE menu

func import_library() -> void:
	file_dialog.popup()

func _file_dialog_dir_selected(dir):
	Global.library_path = dir

# ------------------------------------------------------------------------------
