extends Camera2D

var target = self
var speed = 5
var level = 1

# Lower cap for the `_zoom_level`.

# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 0.1
# Duration of the zoom's tween animation.


# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _process(delta):
	if target != self and is_instance_valid(target):
		self.offset = target.position 


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		level += zoom_factor
		
	if event.is_action_pressed("zoom_out"):
		level -= zoom_factor
	
	zoom = Vector2(level, level)
