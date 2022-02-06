extends Node2D

func draw_square(center, color):
	var posses = [Vector2(-5, -5)+center, Vector2(-5, 5)+center, Vector2(5, 5)+center, Vector2(5, -5)+center]

	var colors = PoolColorArray([color])
	draw_polygon(posses, colors)

func drawhome():
	var somecolor = Color(1, 0, 0, 1)
	draw_square(Vector2(0,0), somecolor)
