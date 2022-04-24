extends Node2D

var DirectionTextGen = preload("res://DirectionTextGenerator.gd").new()
var filehandler = preload("res://filehandler.gd").new()

var scene = preload("res://travel_nodes/travelnode.tscn")
var player = preload("res://player.tscn")

var nodes = []
var allscore = 0
var oldscore = 0
var samecount = 0
var numberOfNodes = 10
var simulationdone = false

var totalcenter = Vector2()
var activeplayer = null
var cam = null
var astar = null
var backgroundtextures = []
var allportraits = null
var canvas3 = null
var startdone = false
var menu = null

func _ready():
	self.cam = get_tree().get_root().get_child(0).get_child(2)
	self.canvas3 = get_tree().get_root().get_child(0).get_child(0)
	self.menu = get_tree().get_root().get_child(0).get_node("menulayer")
	self.allportraits = filehandler.get_files("./portraits", "png")
	self.backgroundtextures = filehandler.get_files("./landscapes", "png")

	set_process(true)
	make_balls()

func make_balls():
	# Randomize number of balls
	numberOfNodes = numberOfNodes + rand_range(1, 25)
	
	# Make new travel node instances
	for x in self.numberOfNodes:
		var nodeInstance = scene.instance()
		nodeInstance.currentbackground = random_from_list(self.backgroundtextures)
		self.nodes.append(nodeInstance)

	self.nodes[0].rootstart = true
	for x in self.nodes:
		x.allballs = self.nodes
		self.add_child(x)

	for x in self.nodes:
		random_connect(x, 3)

func random_from_list(list):
	return list[randi() % list.size()]

func random_choice(x, smal):
	var goodchoice = false
	var choice = 0
	while not goodchoice:
		choice = randi() % self.nodes.size()
		if self.nodes[choice].rootstart and self.nodes[choice].neighbors.size() < smal:
			goodchoice = true
	return choice


func random_connect(x, small):
	var newindex = random_choice(x, small)
	if newindex <= self.nodes.size()-1:

		x.add_neighbor(self.nodes[newindex])
		self.nodes[newindex].add_neighbor(x)
		
		if x.startatpos:
			x.position = nodes[newindex].position + (self.totalcenter.normalized() * 10)
			
		self.nodes[newindex].rootstart = true
		x.rootstart = true
		x.nodesettlescore = 0
		self.nodes[newindex].nodesettlescore = 0 


func _process(delta):
	for x in self.nodes:
		self.totalcenter += x.position
		
	for x in self.nodes:
		x.avgcenter = self.totalcenter/ self.nodes.size()
	
	self.nodes.shuffle()
	if self.nodes.size() < self.numberOfNodes:
		reconnect_slow_ball()

	for x in self.nodes:
		self.allscore += x.nodesettlescore
		
	if self.oldscore == self.allscore:
		self.samecount += 1
	
	self.oldscore = self.allscore
	self.allscore = 0

	if self.samecount > 100 and not self.simulationdone and self.startdone:
		hide_loading_screen()
		self.simulationdone = true
		set_process(false)

		var nodesindexes = longest_route()
		var duplicate = nodesindexes.duplicate()

		set_endnode(nodesindexes)
		set_startnode(nodesindexes)
		
		var enemyroam = get_splitnode_index(nodesindexes)[-1]


		set_enemy(nodesindexes)

		self.cam.target = nodesindexes[0]
		
		random_food_placer(self.nodes)
		random_water_placer(nodesindexes)
		random_route_indicator(nodesindexes)
		nodesindexes[0].clickit()
		
		for node in self.nodes:
			node.simulate = false

func reconnect_slow_ball():
		self.nodes.append(scene.instance())
		self.nodes[-1].currentbackground = random_from_list(self.backgroundtextures)
		self.nodes[-1].allballs = self.nodes
		self.nodes[-1].startatpos = true
		
		self.add_child(self.nodes[-1])
		random_connect(self.nodes[-1], 2)

func set_enemy(nodeindexes):
	nodeindexes[-5].enemy = true

func set_endnode(nodesindexes):
	var endSceneTexture = filehandler.get_files("./end-scenes", "png")
	nodesindexes[-1].currentportrait = random_from_list(self.allportraits)
	nodesindexes[-1].currentbackground = endSceneTexture[0]
	nodesindexes[-1].directiontext = "Welcome to your new home nephew, you are safe here.\nIt will take months before the army of darkness will reach these parts of the land."
	nodesindexes[-1].isEndNode = true
	

func set_startnode(nodesindexes):
	nodesindexes[0].setplayer(player.instance())
	nodesindexes[0].currentportrait = random_from_list(self.allportraits)
	nodesindexes[0].directiontext = "Dear prince, the armies of darkness are approaching.\nYou need to flee to your uncle and aunt in the area of {place}".format({"place": nodesindexes[-1].realname})

func random_food_placer(duplicate):
	for x in duplicate:
		if  randi() % 3 > 0:
			x.food = true

func random_water_placer(duplicate):
	for x in duplicate:
		if neighborwater(x) == 0:
			x.water = true

func random_route_indicator(nodesindexes):
	var lel = get_splitnode_index(nodesindexes)
		
	for x in lel:
		var present = randi() % 3
		if present > 0:
			add_route_indicators(x, nodesindexes)

func hide_loading_screen():
	self.canvas3.get_node("backgroundsprite").hide()
	self.canvas3.get_node("AnimationPlayer").stop()
	self.canvas3.get_node("loadingsprite").hide()
#
#func get_a_split(nodesindexes):
#	for node in nodesindexes:
#		if node.neighbors

func add_route_indicators(lel, nodesindexes):
	var aStarNodes = astar.get_id_path(lel.get_instance_id(), nodesindexes[0].get_instance_id())
		
	var anode = instance_from_id(aStarNodes[1])

	for neighbourNode in instance_from_id(aStarNodes[0]).neighbors:
		var direction = null
		var place = null
		if neighbourNode != anode:
			anode.currentportrait = random_from_list(self.allportraits)
			direction =  DirectionTextGen.getdirection(instance_from_id(aStarNodes[0]).position, neighbourNode.position)
			place = instance_from_id(aStarNodes[0]).realname
			anode.directiontext = DirectionTextGen.createStory(neighbourNode in nodesindexes, randi(), direction, place)
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

func neighborwater(node):
	var water = 0
	for x in node.neighbors:
		water += int(x.water)
	return water

func route_resources(listonodes):
	var totalfood = 0
	for x in listonodes:
		totalfood += int(x.food)
	return totalfood

func longest_route():
	astar = AStar2D.new()
	for x in self.nodes:
		astar.add_point(x.get_instance_id(), x.position)

	for x in self.nodes:
		for y in x.neighbors:
			astar.connect_points(x.get_instance_id(), y.get_instance_id(), false)
	
	var longestpath = []
	var endnodes = []
	var longestnodes = []
	
	for x in self.nodes:
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
	self.menu.get_node('backmenu').show()

func moveenemy():
	for node in self.nodes:
		if node.enemy:
			node.enemy = false
			node.random_neighbor().enemy = true
			
