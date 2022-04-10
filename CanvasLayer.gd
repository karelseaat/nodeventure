extends CanvasLayer

var player
var live
var food
var rootscene

func _ready():
	food = $ui/VBoxContainer/HBoxContainer2/FoodLabel
	live  = $ui/VBoxContainer/HBoxContainer/LiveLabel
	rootscene = get_tree().root.get_child(0).get_child(2).get_child(0)
	print(live.name)
	set_process(true)
#
func _process(delta):
	if rootscene.simulationdone and is_instance_valid(rootscene.activeplayer):
		food.text = String(rootscene.activeplayer.food) + " x "
		live.text = String(rootscene.activeplayer.live) + " x "

