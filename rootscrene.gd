extends Node2D

var scene = preload("res://travelnode.tscn")
var nodes = []
var allscore = 0
var oldscore = 0
var samecount = 0

func random_choice(x):
	var goodchoice = false
	var choice = 0
	while not goodchoice:
		choice = randi() % nodes.size()
		if nodes[choice].rootstart:
			goodchoice = true
	
	return choice
	
func random_connect():
	var found
	var node
	nodes.shuffle()
	for x in nodes:
		
		var newindex = random_choice(x)

		if newindex <= nodes.size()-1 :

			x.add_neighbor(nodes[newindex])
			nodes[newindex].add_neighbor(x)
			nodes[newindex].rootstart = true
			x.rootstart = true


func _ready():
	set_process(true)
	for x in 20:
		nodes.append(scene.instance())
	
	nodes[0].rootstart = true
	for x in nodes:
		x.allballs = nodes
		self.add_child(x)
		
	random_connect()

func _process(delta):
	var totalcenter = Vector2()
	for x in nodes:
		totalcenter += x.position
		
	for x in nodes:
		x.avgcenter = totalcenter/ nodes.size()
	
	nodes.shuffle()
	
	for x in nodes:
		allscore += x.score
		
	if oldscore == allscore:
		samecount += 1
	
	oldscore = allscore
	allscore = 0
	



