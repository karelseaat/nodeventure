extends CanvasLayer

var player
var live
var food
var rootscene

func _ready():
	food = $ui/VBoxContainer/FoodLabel
	live  = $ui/VBoxContainer/LiveLabel
	rootscene = get_tree().root.get_child(0).get_child(2).get_child(0)
	set_process(true)
#
func _process(delta):
	if rootscene.simulationdone and is_instance_valid(rootscene.activeplayer):
		food.text = "Food: " + String(rootscene.activeplayer.food)
		live.text = "Live: " + String(rootscene.activeplayer.live)

