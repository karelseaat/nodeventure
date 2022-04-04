extends Object


func get_files(dirpath: String, filter: String):
	var dir = Directory.new()
	dir.open(dirpath)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var files = []

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		
		if not dir.current_is_dir() and filter in  path.split(".")[-1]:
			files.append(load(path))

		file_name = dir.get_next()

	dir.list_dir_end()
	return files
