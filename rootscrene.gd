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
			x.position = nodes[newindex].position +  Vector2( ((randi() % 5)-2.5) * 10, ((randi() % 5)-2.5)*10)
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
		self.add_child(x)

	for x in nodes:
		random_connect(x, 3)

func _process(delta):
	var totalcenter = Vector2()
	
	for x in nodes:
		totalcenter += x.position
		
	for x in nodes:
		x.avgcenter = totalcenter/ nodes.size()
	
	nodes.shuffle()
	
	if nodes.size() < balls:
		nodes.append(scene.instance())
		nodes[-1].allballs = nodes
		nodes[-1].startatpos = true
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

		nodes[0].setplayer(player.instance())
		longest_route()

func longest_route():
	print(nodes[0].get_instance_id())
#	var astar = AStar.new()
#	astar.add_point(1, Vector3(1, 1, 0))
#	astar.add_point(2, Vector3(0, 5, 0))
#	astar.connect_points(1, 2, false)
