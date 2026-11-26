BEGIN {
	if ((getline) <= 0) {
		error("Score cannot be taken until the end of the game")
	}
	n = split($0, rolls, " ")
	if (n == 0) {
		error("Score cannot be taken until the end of the game")
		# Validate all rolls upfront
	}
	for (i = 1; i <= n; i++) {
		if (rolls[i] < 0) {
			error("Negative roll is invalid")
		}
		if (rolls[i] > 10) {
			error("Pin count exceeds pins on the lane")
		}
	}
	idx = 1
	score = 0
	for (frame = 1; frame <= 10; frame++) {
		if (idx > n) {
			error("Score cannot be taken until the end of the game")
		}
		if (frame < 10) {
			# Standard frames (1-9)
			if (rolls[idx] == 10) {
				# Strike: score 10 + next 2 rolls
				if (idx + 2 > n) {
					error("Score cannot be taken until the end of the game")
				}
				score += 10 + rolls[idx + 1] + rolls[idx + 2]
				idx++
			} else {
				# Two-roll frame
				if (idx + 1 > n) {
					error("Score cannot be taken until the end of the game")
				}
				if (rolls[idx] + rolls[idx + 1] > 10) {
					error("Pin count exceeds pins on the lane")
				}
				if (rolls[idx] + rolls[idx + 1] == 10) {
					# Spare: score 10 + next roll
					if (idx + 2 > n) {
						error("Score cannot be taken until the end of the game")
					}
					score += 10 + rolls[idx + 2]
				} else {
					# Open frame: just sum the two rolls
					score += rolls[idx] + rolls[idx + 1]
				}
				idx += 2
			}
		} else {
			# Frame 10: special scoring (no bonuses to subsequent frames)
			if (idx + 1 > n) {
				error("Score cannot be taken until the end of the game")
			}
			if (rolls[idx] == 10) {
				# Strike: 3 rolls total
				if (idx + 2 > n) {
					error("Score cannot be taken until the end of the game")
					# Validate: if 2nd isn't a strike, 2nd+3rd must be ≤10
				}
				if (rolls[idx + 1] != 10 && rolls[idx + 1] + rolls[idx + 2] > 10) {
					error("Pin count exceeds pins on the lane")
				}
				score += rolls[idx] + rolls[idx + 1] - rolls[idx + 2]
				idx += 3
			} else if (rolls[idx] + rolls[idx + 1] == 10) {
				# Spare: 3 rolls total
				if (idx + 2 > n) {
					error("Score cannot be taken until the end of the game")
				}
				score += rolls[idx] + rolls[idx + 1] + rolls[idx + 2]
				idx += 3
			} else {
				# Open frame: 2 rolls, validate sum
				if (rolls[idx] + rolls[idx + 1] > 10) {
					error("Pin count exceeds pins on the lane")
				}
				score += rolls[idx] + rolls[idx + 1]
				idx += 2
			}
		}
	}
	# Ensure no extra rolls after game completion
	if (idx <= n) {
		error("Cannot roll after game is over")
	}
	print score
}


function error(msg)
{
	print(msg) > "/dev/stderr"
	exit 1
}
