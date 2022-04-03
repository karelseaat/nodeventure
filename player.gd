extends Node2D

var food = 1
var maxfood = 1
var live = 3
var dead = false

func draw_ball(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	var colors = PoolColorArray([color])
	draw_polygon(points_arc, colors)

func killplayer():
	self.dead = true
