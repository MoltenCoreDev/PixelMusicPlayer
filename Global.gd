extends Node
# TODO: DOCS

# ------------------------------------------------------------------------------
export(String, DIR) var library_path setget _library_path_changed
export(Resource) var library
# ------------------------------------------------------------------------------

# Main Control Node of the software
onready var main: Control = get_tree().get_root().get_node("Control")

# ------------------------------------------------------------------------------

signal library_path_changed

# ------------------------------------------------------------------------------

func _library_path_changed(path: String) -> void:
	library_path = path
	
	var files := _find_files(path)
	emit_signal("library_path_changed", files)

# ------------------------------------------------------------------------------
# Returns an array with all subdirectories of the directory
func _find_files(path: String) -> Array:
	var dir := Directory.new()
	var files := []
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				files.append_array(_find_files(path + "/" + file_name))
			else:
				files.append(path + "/" + file_name)
			file_name = dir.get_next()
	return files
