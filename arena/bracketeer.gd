extends Node

const EPSILON: float = 1e-5

var _contestants: Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
var _bracket: Dictionary

func _ready() -> void:
	# get nearest power of 2 greater or equal to num_contestants
	var upper_bracket_template: Dictionary
	var num_contestants := len(_contestants)
	var remaining_contestants: int = num_contestants
	var log2 := log(num_contestants) / log(2)
	var num_rounds := ceili(log2)
	print("rounds: ", num_rounds)
	print("---------------------")
	for i in num_rounds:
		print("round ", i + 1)
		var slots := 2 ** (num_rounds - i)
		print("slots: ", slots)
		var num_matches := remaining_contestants - slots / 2
		remaining_contestants -= num_matches
		var round: Array
		round.resize(slots)
		#round.fill(0)
		if i == 0:
			var k: int = 0
			for j in num_matches:
				if k >= slots / 2:
					k = 1
				round[2 * k] = -1
				round[2 * k + 1] = -1
				k += 2
		upper_bracket_template[i] = round
		print(round)


	# fill upper bracket template
	var contestant_copy := _contestants.duplicate()
	contestant_copy.shuffle()
	var k := 0
	var j := 0
	for i in len(upper_bracket_template[0]):
		if j >= len(upper_bracket_template[0]):
			break
		var slot = upper_bracket_template[0][j]
		if slot == -1:
			upper_bracket_template[0][j] = contestant_copy[k]
			k += 1
		else:
			upper_bracket_template[1][j/2] = contestant_copy[k]
			k += 1
			j += 1
		j += 1
	print(upper_bracket_template)
	print(len(upper_bracket_template))
	#make_bracket(_contestants)

	# Dict -> upper -> final



func make_bracket(contestants: Array):
	var im_contestants := contestants.duplicate()
	var log2 := log(len(im_contestants)) / log(2)

	if absf(fmod(log2, 1)) < EPSILON:
		print("2^", log2)
	else:
		print("2^", floori(log2), " + ", len(im_contestants) - 2**floori(log2))

	if len(im_contestants) % 2 != 0:
		var advance = select_bye(im_contestants)
		print(im_contestants)
		print(contestants)
		print(advance)
	else:
		randomize()
		contestants.shuffle()


func select_bye(contestants: Array):
	randomize()
	contestants.shuffle()
	return contestants.pop_back()
