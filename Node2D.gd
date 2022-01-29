extends Node2D

var neighbors : Array = []
var allballs : Array = []

var water = false
var food = false
var map  : Array = []
var envstory = ""
var enemy
var exit = false
var person
var environment
var discovered = false
var center = Vector2(0,0)
var avgcenter
var score = 1
var rootstart = false

func _ready():
	randomize()
	self.position = Vector2((randi() % 10)*100, (randi() % 6)*100)
	set_process(true)




func _process(delta):
	var speed = 1
	
	for x in allballs:
		var distance = self.position.distance_to(x.position)
		if distance < 150:
			position -= position.direction_to(x.position) * (distance + speed)  * delta

	for x in neighbors:
		var distance = self.position.distance_to(x.position)
		if distance > 250:
			score += 1
			x.score += 1
			position = position.move_toward(x.position, delta * (distance + speed))

	if score > 40 and neighbors.size() == 1:
#		score = 0
#		self.position =  neighbors[0].position - self.position 
		remove_neighbors()
		allballs.erase(self)
		queue_free()

	update()

func remove_neighbors():
	for x in neighbors:
		x.neighbors.erase(self)
	

func add_neighbor(node):
	neighbors.append(node)

func draw_ball(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	var colors = PoolColorArray([color])
	draw_polygon(points_arc, colors)

func draw_circle_arc(center, radius, angle_from, angle_to, color, width):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, width)
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, width+1)
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, width+3)

func _draw():
	draw_parts()
	draw_connections()

func draw_connections():
	var color = Color(0, 0, 0, 1)
	for x in neighbors:
		draw_line(Vector2(0,0), x.transform[2] -  self.transform[2], color, 3)

func draw_parts():

	var offset1 = Vector2(-50,   -100)
	var offset2 = Vector2(50,  -100)
	var offset3 = Vector2(0,  -110)
	var radius = 80
	var angle_from = 0
	var angle_to = 360
	var color = Color(0.1, 0.1, 0.1, 0.1)
	draw_circle_arc(Vector2(0,0), radius, angle_from, angle_to, color, 1)
	draw_ball(Vector2(0,0), radius, angle_from, angle_to, color)
	draw_circle_arc(offset1, 15, angle_from, angle_to, color, 1)
	draw_circle_arc(offset2, 15, angle_from, angle_to, color, 1)
	draw_circle_arc(offset3, 15, angle_from, angle_to, color, 1)
