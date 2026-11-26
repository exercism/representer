package yacht

import "strings"

func Score(dice []int, category string) int {
	scoreCount := make(map[int]int)
    for _, c := range dice {
        scoreCount[c]++
    }
    category = strings.ToLower(category)
    switch category {
        case "ones":
        	return scoreCount[1]
        case "twos":
        	return scoreCount[2] * 2
        case "threes":
        	return scoreCount[3] * 3
        case "fours":
        	return scoreCount[4] * 4
        case "fives":
        	return scoreCount[5] * 5
        case "sixes":
        	return scoreCount[6] * 6
        case "full house", "four of a kind", "yacht":
        	return calculate(scoreCount, category)
        case "little straight", "big straight":
			return straightCalc(scoreCount, category)
        case "choice":
        	return choice(scoreCount)
    }
    return 0
}

func straightCalc(s map[int]int, cat string) int {
    if s[2] == s[3] && s[3] == s[4] && s[4] == s[5] && s[2] == 1 {
        if (s[1] == 1 && cat == "little straight") || (s[6] == 1 && cat == "big straight"){
            return 30
        }
    }
    return 0
}

func choice(s map[int]int) int {
    var total int
    for i, v := range s {
        if v > 0 {
        	total += i * v
        }
    }
    return total
}

func calculate(s map[int]int, cat string) int {
    var score int
    var fh2, fh3 bool
    for k, v := range s {
        if v == 3 && cat == "full house"{
            score += k * v
            fh2 = true
        } else if v == 2 && cat == "full house"{
            score += k * v
            fh3 = true
        } else if (v == 4 || v == 5) && cat == "four of a kind" {
            return k * 4
        } else if v == 5 && cat == "yacht" {
            return 50
        }
    }
    if fh2 && fh3 {
        return score
    }
    return 0
}