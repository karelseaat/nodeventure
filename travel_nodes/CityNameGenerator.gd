extends Node2D

var names1 = ["Green", "Rose", "Skill", "Hellen", "Clam", "Winter", "Snow", "Oak", "Kings", "Queens", "Law"]
var names2 = ["wich" ,"view", "dam", "dune", "woods", "ford", "field", "ham", "fields", "hills", "plain"]
var prefix = ["Great", "Lesser", "New", "South", "East", "North", "West"]

func randname():
	var name1 = names1[randi() % names1.size()]
	var name2 = names2[randi() % names2.size()]
	var prefixName = ""
	if (randi() % 5) > 3:
		prefixName = prefix[randi() % prefix.size()]
	
	return prefixName + " " + name1 + name2
