extends Node2D

var scene = preload("res://travelnode.tscn")
var nodes = []
var allscore = 0
var oldscore = 0
var samecount = 0
var balls = 30
var current
var simulationdone = false
var player = preload("res://player.tscn")
var home = preload("res://home.tscn")
var totalcenter = Vector2()
var activeplayer = null
var cam



func random_choice(x, smal):
	var goodchoice = false
	var choice = 0
	while not goodchoice:
		choice = randi() % nodes.size()
		if nodes[choice].rootstart and nodes[choice].neighbors.size() < smal:
			goodchoice = true
	
	return choice
	
func random_connect(x, small):

	var newindex = random_choice(x, small)
	if newindex <= nodes.size()-1:

		x.add_neighbor(nodes[newindex])
		nodes[newindex].add_neighbor(x)
		if x.startatpos:

			x.position = nodes[newindex].position + (totalcenter.normalized() * 10)
		nodes[newindex].rootstart = true
		x.rootstart = true
		x.score = 0
		nodes[newindex].score = 0 

func setcur(curr):
	current = curr

func _ready():
	set_process(true)
	for x in balls:
		nodes.append(scene.instance())
		
	nodes[0].rootstart = true
	for x in nodes:
		x.allballs = nodes
#		x.realname = randname()
		self.add_child(x)

	for x in nodes:
		random_connect(x, 3)
		
	cam = get_tree().get_root().get_child(0).get_child(1)

func _process(delta):
	
	for x in nodes:
		totalcenter += x.position
		
	for x in nodes:
		x.avgcenter = totalcenter/ nodes.size()
	
	nodes.shuffle()
	
	if nodes.size() < balls:
		nodes.append(scene.instance())
		nodes[-1].allballs = nodes
		nodes[-1].startatpos = true
		
		
#		nodes[-1].realname = randname()
		self.add_child(nodes[-1])
		random_connect(nodes[-1], 2)

	
	for x in nodes:
		allscore += x.score
		
	if oldscore == allscore:
		samecount += 1
	
	oldscore = allscore
	allscore = 0


	if samecount > 500 and not simulationdone:
		simulationdone = true
		set_process(false)
		var nodesindexes = longest_route()
		var duplicate = nodesindexes.duplicate()
		var klont = duplicate.pop_back()
		klont.water = false
		klont.food = false


		nodesindexes[0].setplayer(player.instance())

		cam.target = nodesindexes[0]
		nodesindexes[-1].sethome(home.instance())
		var totals = route_resources(duplicate)
		
		for x in duplicate:
			if neighborwater(x) == 0:
				x.water = true

			if neighborfood(x) == 0:
				x.food = true
			totals = route_resources(duplicate)

func neighborfood(node):
	var food = 0
	for x in node.neighbors:
		food += int(x.food)
	return food

func neighborwater(node):
	var water = 0
	for x in node.neighbors:
		water += int(x.water)
	return water

func enough_water(listonodes, totals):
	var size = listonodes.size()
	return totals[0] >= (size/2)
		
func enough_food(listonodes, totals):
	var size = listonodes.size()
	return totals[1] >= (size/2)

func route_resources(listonodes):
	var totalwater = 0
	var totalfood = 0
	var totalenemy = 0
		
	for x in listonodes:
		totalwater += int(x.water)
		totalfood += int(x.food)
		totalenemy += int(x.enemy)

	return [totalwater, totalfood, totalenemy]

func longest_route():

	var astar = AStar2D.new()
	for x in nodes:
		astar.add_point(x.get_instance_id(), x.position)

	for x in nodes:
		for y in x.neighbors:
			astar.connect_points(x.get_instance_id(), y.get_instance_id(), false)
	
	var longestpath = []
	var endnodes = []
	var longestnodes = []
	
	for x in nodes:
		if x.neighbors.size()  == 1:
			endnodes.append(x)
			
	for x in range(10):

		var start = randi() % endnodes.size()
		var end = randi() % endnodes.size() 
		var temppath = astar.get_id_path(endnodes[start].get_instance_id(), endnodes[end].get_instance_id())

		if temppath.size() > longestpath.size():
			longestpath = temppath
			
	for x in longestpath:
		longestnodes.append(instance_from_id(x))

	return longestnodes
		
