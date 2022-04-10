extends CanvasLayer

var backgroundtextures = null
var backgroundsprite = null
var mainmenu = null
var backmenu = null
var animationplayer = null
var loadingsprite = null
var score_board = null
var filehandler = preload("res://filehandler.gd").new()

func _ready():
	animationplayer = $AnimationPlayer
	backgroundtextures = filehandler.get_files("./landscapes", "png")
	backgroundsprite = $backgroundsprite
	mainmenu = $mainmenu
	backmenu = $backmenu
	loadingsprite = $loadingsprite
	score_board = get_tree().root.get_child(0).get_child(1).get_child(0)
	backgroundsprite.texture = backgroundtextures[randi() % backgroundtextures.size()]


func _on_Button_pressed():
	mainmenu.hide()
	animationplayer.play("loadingplay")
	loadingsprite.show()
	var cam = get_tree().root.get_child(0).get_child(2)
	score_board.show()
	cam.get_child(0).startdone = true

func _on_Button4_pressed():
	get_tree().quit()

func _on_backtomain_pressed():
	var cam = get_tree().root.get_child(0).get_child(2)
	mainmenu.show()
	backmenu.hide()
	score_board.hide()
	cam.get_child(0).set_process(true)
	cam.get_child(0).simulationdone = false
	cam.get_child(0).startdone = true
	cam.get_child(0).samecount = 0
	for x in cam.get_child(0).nodes:
		x.queue_free()
	cam.get_child(0).nodes = []
	cam.get_child(0).make_balls()
