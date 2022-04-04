extends Object

func getdirection(vec1, vec2):
	var direction = rad2deg((vec1 - vec2).angle())
	if direction < 0:
		direction = direction + 360

	if direction > -22.5 and direction < 22.5:
		return "west"
	elif direction > 22.5 and direction < 67.5:
		return "north west"
	elif direction > 67.5 and direction < 112.5:
		return "north"
	elif direction > 112.5 and direction < 157.5:
		return "north east"
	elif direction > 157.5 and direction < 202.5:
		return "east"
	elif direction > 202.5 and direction < 247.5:
		return "south east"
	elif direction > 247.5 and direction < 292.5:
		return "south"
	elif direction > 292.5 and direction < 337.5:
		return "south west"

var goodstories = [
	"I'm quite sure that at {place} the {str} direction is a good path.",
	"I saw people traveling on the {str} path from {place}. Must be a good one!",
	"My parents told me that there is a trading route on the {str} path at {place}.",
	"I always go to the market via the {str} at the {place} split."
]

var badstories = [
	"Don't take the {str} path at {place}, because it leads to nowhere!",
	"I saw no one return from the {str} path on the {place} split.",
	"Adventurers have traveled the {str} path at {place}, but they said there is noting find there.",
	"The people that traveled the {str} path at {place} didn't return at all. Beware!"
]

# Generate formatted good story text
func createStory(goodStory, randomNumber, direction, place):
	if goodStory:
		return goodstories[randomNumber % goodstories.size()].format({"str": direction, "place": place})
	else:
		return badstories[randomNumber % badstories.size()].format({"str": direction, "place": place})
