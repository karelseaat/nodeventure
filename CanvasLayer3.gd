extends CanvasLayer

var backgroundtextures = null
var backgroundsprite = null
var mainmenu = null
var animationplayer = null
var loadingsprite = null
var filehandler = preload("res://filehandler.gd").new()

func _ready():
	animationplayer = $AnimationPlayer
	backgroundtextures = filehandler.get_files("./landscapes", "png")
	backgroundsprite = $backgroundsprite
	mainmenu = $mainmenu
	loadingsprite = $loadingsprite
	backgroundsprite.texture = backgroundtextures[randi() % backgroundtextures.size()]


func _on_Button_pressed():
	mainmenu.hide()
	animationplayer.play("loadingplay")
	loadingsprite.show()
	var cam = get_tree().root.get_child(0).get_child(2)
	var klont = get_tree().root.get_child(0).get_child(1)
	klont.get_child(0).show()
	klont.get_child(1).show()
	cam.get_child(0).startdone = true

func _on_Button4_pressed():
	get_tree().quit()

func _on_backtomain_pressed():
	print("backtomain")
