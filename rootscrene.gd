extends Node2D

var scene = preload("res://travelnode.tscn")
var nodes = []
var allscore = 0
var oldscore = 0
var samecount = 0

func random_choice():
	return nodes[randi() % nodes.size()]
	
func random_connect():
	var found
	var node
	for x in nodes:
		found = false
		while not found:
			node = random_choice()
			if node != x and node.position.distance_to(x.position) < 300:
				x.add_neighbor(node)
				node.add_neighbor(x)
				found = true

func _ready():
	set_process(true)
	for x in 20:
		nodes.append(scene.instance())
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
	
	if samecount > 200:
		getgroups()
	
	oldscore = allscore
	allscore = 0
	

func getgroups():
	pass

