extends Node2D

var allowednodes = null
var currentnode = null

func random_from_list(list):
	if list:
		return list[randi() % list.size()]

func moveenemy():
	return random_from_list(allowednodes)
	
