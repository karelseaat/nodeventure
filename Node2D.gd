extends Node2D

var cityNameGen = preload("res://travel_nodes/CityNameGenerator.gd").new()

var neighbors : Array = []
var allballs : Array = []

var food = false
var water = false

var isEndNode = false
var player
var enemy = null
var discovered = true
var center = Vector2(0,0)
var avgcenter
var nodesettlescore = 1
var rootstart = false
var startatpos = false
var visiblelevel = 0
var parent = null
var nodepulseplay = false
var realname = ""
var rootscene = null
var backscene = null
var label = null
var foodsprite = null
var watersprite = null
var animationplayer = null
var simulate = true

var color = Color(0.4, 0.4, 0.4, 1)
var somecolor = Color(0.9, 0.9, 0.9, 1)
var colordark = Color(0.1, 0.1, 0.1, 1)

var directiontext = ""
var currentbackground = null
var currentportrait = null

func _ready():

	label = $Label
	foodsprite = $Sprite
	foodsprite.position = Vector2(-50, -100)
	watersprite =  $Spritetwee
	watersprite.position = Vector2(50, -100)
	
	animationplayer = $AnimationPlayer
	backscene = get_tree().root.get_child(0).get_child(3)
	randomize()
	if not startatpos:
		self.position = Vector2((randi() % 20)*100, (randi() % 8)*100)
	set_process(true)
	rootscene = get_tree().root.get_child(0).get_child(2).get_child(0)
	self.realname = cityNameGen.randname()


func _process(delta):
	pass
	var speed = 5

	if self.nodepulseplay and not self.player:
		self.nodepulseplay = false
		animationplayer.play("stop")

	if self.player and is_instance_valid(self.player):
		if not self.nodepulseplay:
			self.nodepulseplay = true
			animationplayer.play("vibe")
		self.get_parent().activeplayer = player
		self.visiblelevel = 2
		for x in self.neighbors:
			if x.visiblelevel < 1:
				x.visiblelevel = 1

	if simulate:

		for x in allballs:
			var distance = self.position.distance_to(x.position)
			if distance < 250:
				position -= position.direction_to(x.position) * (distance + speed)  * delta


		for x in neighbors:
			var distance = self.position.distance_to(x.position)
			if distance > 350:
				nodesettlescore += 1

				position = position.move_toward(x.position, delta * (distance + speed))

		if nodesettlescore > 23 and neighbors.size() <= 2:

			remove_neighbors()
			allballs.erase(self)
			queue_free()
	update()

func remove_neighbors():
	for x in neighbors:
		x.neighbors.erase(self)
	
	if neighbors.size() == 2 :
		neighbors[0].neighbors.append(neighbors[1])
		neighbors[1].neighbors.append(neighbors[0])

	if neighbors.size() == 3 :
		neighbors[0].neighbors.append(neighbors[1])
		neighbors[1].neighbors.append(neighbors[2])
		neighbors[2].neighbors.append(neighbors[0])

func add_neighbor(node):
	neighbors.append(node)

func random_from_list(list):
	return list[randi() % list.size()]

func random_neighbor():
	return self.random_from_list(self.neighbors)
	

func draw_ball(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	
	var colors = PoolColorArray([color])
	draw_polygon(points_arc, colors)

func draw_square(center, extra, color):
	var posses = [Vector2(-extra, -extra)+center, Vector2(-extra, extra)+center, Vector2(extra, extra)+center, Vector2(extra, -extra)+center]
	var colors = PoolColorArray([color])
	
	draw_polygon(posses, colors)

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
	if self.discovered:
		draw_connections()
		draw_parts()
		draw_enemy()
		draw_player()


func draw_enemy():
	if enemy and self.visiblelevel >= 1:
		draw_ball(Vector2(0,0), 50, 0, 360, Color(255,0,0))

func draw_player():
	if player and player.dead == false:
		draw_ball(Vector2(0,0), 40, 0, 360, somecolor)

func draw_connections():
	if self.visiblelevel == 2:
		var color = Color(0.1, 0.1, 0.1, 1)
		for x in neighbors:
			var dist = x.transform[2].distance_to(self.transform[2]) - 80
			var angle = x.transform[2].angle_to_point(self.transform[2])
			var klont2 = Vector2(cos(angle), sin(angle)) * dist
			draw_line(Vector2(0,0), klont2, color, 6)

func draw_parts():

	var offset1 = Vector2(-50,   -100)
	var offset3 = Vector2(50,  -100)
	var offset2 = Vector2(0,  -110)
	var radius = 80
	var angle_from = 0
	var angle_to = 360

	if self.visiblelevel >= 1:
		label.text = self.realname
		draw_ball(Vector2(0,0), radius+5, angle_from, angle_to, colordark)
		draw_ball(Vector2(0,0), radius, angle_from, angle_to, color)

	if self.visiblelevel == 2 and self.food:
		foodsprite.visible = true
	else:
		foodsprite.visible = false

	if self.visiblelevel == 2 and self.water:
		watersprite.visible = true
	else:
		watersprite.visible = false
#

	if self.visiblelevel >= 1:
		draw_ball(offset1, 30, angle_from, angle_to, colordark)
		draw_ball(offset1, 25, angle_from, angle_to, color)
		
		draw_ball(offset3, 30, angle_from, angle_to, colordark)
		draw_ball(offset3, 25, angle_from, angle_to, color)

func setplayer(player):
	self.player = player

func moveplayer():
	for x in neighbors:
		if x.player and x.player.dead == false:
			self.player = x.player
			x.player = null

	if self.player and is_instance_valid(self.player):
		if self.food and self.player.food <= self.player.maxfood:
			self.player.food = self.player.maxfood
		else:
			self.player.food -= 1
	
		if self.water and self.player.water <= self.player.maxwater:
			self.player.water = self.player.maxwater
		else:
			self.player.water -= 1
	
		if self.player.food < 0:
			self.player.live -= 1
			self.player.food = 0
			
		if  self.player.water < 0:
			self.player.live -= 1
			self.player.water = 0
		
		if self.player.live == 0:
			self.player.killplayer()
		
func clickit():
	backscene.get_child(0).set_texture(currentbackground)
	backscene.get_child(0).scale = Vector2(1, 1)
	
	rootscene.moveenemy()
	
	if is_instance_valid(currentportrait):
		backscene.get_child(1).set_texture(currentportrait)
		backscene.get_child(1).scale = Vector2(0.5, 0.5)
		backscene.get_child(2).text = directiontext
	else:
		backscene.get_child(1).set_texture(null)
		backscene.get_child(2).text = ""
	
	if isEndNode:
		backscene.get_child(1).set_texture(null)
		backscene.get_child(2).text = ""
		rootscene.endgame()


