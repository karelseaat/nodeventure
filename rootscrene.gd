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

var totalcenter = Vector2()
var activeplayer = null
var cam
var astar = null
var backgroundtextures =  []
var allports = null
var canvas3 = null
var startdone = false

var goodstorys = [
	"Im qute sure that at {place} the {str} direction is a good path.",
	"I saw people at {place} traveling on the {str} path.",
	"My parents told me that at {place} there is a trading route on the {str} path.",
	"I alwais go to the market via the {str} at the {place} split."
]

var badstorys = [
	"Dont take the {str} path at {place} it leads to nowhere !",
	"I saw no one return from the {str} path on the {place} split.",
	"Adventures have traveled the {str} path at {place} but they said there is noting there.",
	"The people that travled the {str} path at {place} didnt return with good news."
]

func get_files(dirpath: String, filter: String):
	var dir = Directory.new()
	dir.open(dirpath)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var files = []

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		
		if not dir.current_is_dir() and filter in  path.split(".")[-1]:
			files.append(load(path))

		file_name = dir.get_next()

	dir.list_dir_end()
	return files
	

func getdirection(vec1, vec2):
	var klont = rad2deg((vec1 - vec2).angle())
	if klont < 0:
		klont = klont + 360

	if klont > -22.5 and klont < 22.5:
		return "west"
	elif klont > 22.5 and klont < 67.5:
		return "north west"
	elif klont > 67.5 and klont < 112.5:
		return "north"
	elif klont > 112.5 and klont < 157.5:
		return "north east"
	elif klont > 157.5 and klont < 202.5:
		return "east"
	elif klont > 202.5 and klont < 247.5:
		return "south east"
	elif klont > 247.5 and klont < 292.5:
		return "south"
	elif klont > 292.5 and klont < 337.5:
		return "south west"

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
	allports = get_files("./portraits", "png")
	set_process(true)
	for x in balls:
		nodes.append(scene.instance())


	backgroundtextures = get_files("./landscapes", "png")

	nodes[0].rootstart = true
	for x in nodes:
		x.allballs = nodes
		self.add_child(x)

	for x in nodes:
		random_connect(x, 3)
		x.currentbackground = backgroundtextures[randi() % backgroundtextures.size()]
		
	cam = get_tree().get_root().get_child(0).get_child(2)
	canvas3 = get_tree().get_root().get_child(0).get_child(0)

func _process(delta):
	
	for x in nodes:
		totalcenter += x.position
		
	for x in nodes:
		x.avgcenter = totalcenter/ nodes.size()
	
	nodes.shuffle()
	
	if nodes.size() < balls:
		nodes.append(scene.instance())
		nodes[-1].currentbackground = backgroundtextures[randi() % backgroundtextures.size()]
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


	if samecount > 500 and not simulationdone and startdone:
		canvas3.get_node("AnimationPlayer").stop()
		canvas3.get_node("loadingsprite").hide()

		simulationdone = true
		set_process(false)
		var nodesindexes = longest_route()
		var duplicate = nodesindexes.duplicate()
		var klont = duplicate.pop_back()

		klont.food = false

		nodesindexes[0].setplayer(player.instance())
		
		nodesindexes[0].currentportrait = allports[randi() % allports.size()]
		nodesindexes[0].directiontext = "Dear prince, the armys of darkness are aprocing.\nYou need to flee to your uncle and aunt in the area of {place}".format({"place": nodesindexes[-1].realname})

		nodesindexes[-1].currentportrait = allports[randi() % allports.size()]
		nodesindexes[-1].directiontext = "Welcome to you new home nephew, you are save here.\nIt will take months befor the army of darkness will reach these parts of the land."
		nodesindexes[-1].home = true

		cam.target = nodesindexes[0]
		var totals = route_resources(duplicate)
		
		for x in duplicate:
			if neighborfood(x) == 0:
				x.food = true
			totals = route_resources(duplicate)

		var lel = get_splitnode_index(nodesindexes)
		
		for x in lel:
			var present = randi() % 3
			if present > 0:
				add_route_indicators(x, nodesindexes)
	
		nodesindexes[0].clickit()

func add_route_indicators(lel, nodesindexes):
	var testings = astar.get_id_path(lel.get_instance_id(), nodesindexes[0].get_instance_id())
		
	var piep = instance_from_id(testings[1])

	for x in instance_from_id(testings[0]).neighbors:
		var direction = null
		var place = null
		if x != piep:
			piep.currentportrait = allports[randi() % allports.size()]
			if x in nodesindexes: 
				direction =  getdirection(instance_from_id(testings[0]).position, x.position)

				place = instance_from_id(testings[0]).realname
				piep.directiontext = goodstorys[randi() % goodstorys.size()].format({"str": direction, "place": place})
				return
			else:
				direction =  getdirection(instance_from_id(testings[0]).position, x.position)

				place = instance_from_id(testings[0]).realname
				piep.directiontext = badstorys[randi() % badstorys.size()].format({"str": direction, "place": place})
				return

func get_splitnode_index(nodesindexes):
	var splits = []
	for x in nodesindexes:
		if len(x.neighbors) > 2:
			splits.append(x)
	return splits

func neighborfood(node):
	var food = 0
	for x in node.neighbors:
		food += int(x.food)
	return food

func enough_food(listonodes, totals):
	var size = listonodes.size()
	return totals[1] >= (size/2)

func route_resources(listonodes):
	var totalfood = 0
	var totalenemy = 0
		
	for x in listonodes:
		totalfood += int(x.food)

	return [ totalfood, totalenemy]

func longest_route():

	astar = AStar2D.new()
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
	
func endgame():
	canvas3.get_node("AnimationPlayer").play("animatecontrolls")

