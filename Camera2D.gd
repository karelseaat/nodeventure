extends Camera2D

var target = self
var speed = 5
var level = 1
export var zoom_factor := 0.1

func _ready():
	set_process(true)

func _process(delta):
	var speed = 800
	if is_instance_valid(target):
		self.offset = self.offset.move_toward( target.position, delta * speed)

func _unhandled_input(event):
	if Input.is_action_just_released("move") and target != self and is_instance_valid(target) and not target.player:
		target.moveplayer()
	
	if event.is_action_pressed("zoom_in"):
		level += zoom_factor
		
	if event.is_action_pressed("zoom_out"):
		level -= zoom_factor

	zoom = Vector2(level, level)
