extends CanvasLayer

var backgroundtextures = null

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

func _ready():
	backgroundtextures = get_files("./landscapes", "png")
	$backgroundsprite.texture = backgroundtextures[randi() % backgroundtextures.size()]


func _on_Button_pressed():
	$backgroundsprite.hide()
	$MarginContainer.hide()
	
	$AnimationPlayer.play("loadingplay")
	$loadingsprite.show()
	var cam = get_tree().root.get_child(0).get_child(2)
	var klont = get_tree().root.get_child(0).get_child(1)
	klont.get_child(0).show()
	klont.get_child(1).show()
	cam.get_child(0).startdone = true

func _on_Button4_pressed():
	get_tree().quit()


func _on_backtomain_pressed():
	print("backtomain")
