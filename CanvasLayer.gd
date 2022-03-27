extends CanvasLayer

var player
var live
#var water
var food
var rootscene

func _ready():
	food = $"MarginContainer/VBoxContainer/Food label"
	live  = $"MarginContainer/VBoxContainer/Live label"
	
	rootscene = get_tree().root.get_child(0).get_child(2).get_child(0)
	
	set_process(true)
#
func _process(delta):


	if rootscene.simulationdone and is_instance_valid(rootscene.activeplayer):
		food.text = "Food: " + String(rootscene.activeplayer.food)
		live.text = "Live: " + String(rootscene.activeplayer.live)

