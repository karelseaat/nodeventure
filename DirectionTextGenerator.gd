extends Node2D

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
