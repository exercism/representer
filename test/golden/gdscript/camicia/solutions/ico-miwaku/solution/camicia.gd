var cards_a := []
var cards_b := []
var turn := "a"
var pile := []
var play_count := 0
var penalty_count := 0
var history := []


func simulate_game(player_a: Array, player_b: Array) -> Dictionary:
	cards_a = player_a
	cards_b = player_b
	turn = "a"
	pile = []
	play_count = 0
	penalty_count = 0
	history = []

	var status := ""
	var tricks := 0

	while true:
		if pile == []:
			if check_loop():
				status = "loop"
				break
		if simulation_step():
			tricks += 1
			if cards_a == [] and pile == [] or cards_b == [] and pile == []:
				status = "finished"
				break

	return {
		"status": status,
		"cards": play_count,
		"tricks": tricks
	}


func simulation_step() -> bool:
	var cards := cards_a if turn == "a" else cards_b
	var cards_op := cards_b if turn == "a" else cards_a
	var op_player := "b" if turn == "a" else "a"
	
	var top = cards.pop_front()
	match top:
		"2", "3", "4", "5", "6", "7", "8", "9", "10":
			pile.push_back(top)
			play_count += 1
			if penalty_count == 0:		
				turn = op_player
			elif penalty_count == 1:
				penalty_count = 0
				cards_op.append_array(pile)
				pile = []
				turn = op_player
				return true
			else:
				penalty_count -= 1
		"J", "Q", "K", "A":
			pile.push_back(top)
			play_count += 1
			penalty_count = penalty(top)
			turn = op_player
		null:
			cards_op.append_array(pile)
			pile = []
			turn = op_player
			return true
	return false


func penalty(card: Variant) -> int:
	match card:
		"J": return 1
		"Q": return 2
		"K": return 3
		"A": return 4
		_: return 0


func check_loop() -> bool:
	var history_line := ""
	for a in cards_a:
		match a:
			"J", "Q", "K", "A": history_line += a
			_: history_line += "-"
	history_line += "/"
	for b in cards_b:
		match b:
			"J", "Q", "K", "A": history_line += b
			_: history_line += "-"

	if history.find(history_line) >= 0:
		return true
	else:
		history.push_back(history_line)
		return false
