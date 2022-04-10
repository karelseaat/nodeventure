extends CanvasLayer

var player
var live
var food
var water
var rootscene

func _ready():
	water =  $ui/VBoxContainer/WaterHBoxContainer/WaterLabel
	food = $ui/VBoxContainer/FoodHBoxContainer/FoodLabel
	live  = $ui/VBoxContainer/LifeHBoxContainer/LiveLabel


	rootscene = get_tree().root.get_child(0).get_child(2).get_child(0)
	set_process(true)
#
func _process(delta):
	if rootscene.simulationdone and is_instance_valid(rootscene.activeplayer):
		food.text = String(rootscene.activeplayer.food) + " x "
		live.text = String(rootscene.activeplayer.live) + " x "
		water.text = String(rootscene.activeplayer.water) + " x "


