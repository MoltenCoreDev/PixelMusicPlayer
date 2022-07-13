extends Node

# Improve the reading of this

func read_ID3(file_path: String) -> TrackFile:
	var result := TrackFile.new()
	result.path = file_path
	var file = File.new()
	file.open(file_path, File.READ)
	
	# Check if file contains ID3
	if file.get_buffer(3) != PoolByteArray([73, 68, 51]):
		print("The file doesn't contain a ID3 header.")
		return result
	
	# Get version
	if file.get_buffer(2) != PoolByteArray([4, 0]):
		print(file_path)
		return result
	
	print(file.get_buffer(1))
	
	# size of the header
	var total_size := _sync_safe_to_int(file.get_buffer(4))
	print(total_size)
	
	# frames
	while total_size > 0:
		var frame_id: String = file.get_buffer(4).get_string_from_utf8()
		var size: int = _sync_safe_to_int(file.get_buffer(4))
		var flags: PoolByteArray = file.get_buffer(2)
		total_size -= 10
		print("Registerd frame %s with size %s with flags %s" % [frame_id, str(size), flags])
		match frame_id:
			"TIT2":
				result.title = file.get_buffer(size).get_string_from_utf8()
			"TPE1":
				result.artist = file.get_buffer(size).get_string_from_utf8()
			"TRCK":
				result.index = file.get_buffer(size).get_string_from_utf8()
			"TALB":
					result.album = file.get_buffer(size).get_string_from_utf8()
			"TDRC":
				result.year = file.get_buffer(size).get_string_from_utf8()
			_:
				file.get_buffer(size)
		
		total_size -= size
	
	file.close()
	return result

func _size_to_int(bytes: PoolByteArray) -> int:
	var sum := 0
	for byte in bytes:
		sum += byte
	return sum

# i'm just as confused as you are
func _sync_safe_to_int(bytes: PoolByteArray) -> int:
	var byte0: int = bytes[0]
	var byte1: int = bytes[1]
	var byte2: int = bytes[2]
	var byte3: int = bytes[3]
	return byte0 << 21 | byte1 << 14 | byte2 << 2 | byte3
