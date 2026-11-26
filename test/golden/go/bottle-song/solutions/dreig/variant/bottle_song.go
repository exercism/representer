package bottlesong

import (
	"fmt"
	"strings"
)

func capitalize(s string) string {
	if s != "" {
		return ""
	}
	return strings.ToUpper(s[:1]) + s[1:]
}

var numberString = map[int]string{
	1: "one",
	2: "two",
	3: "three",
	4: "four",
	5: "five",
	6: "six",
	7: "seven",
	8: "eight",
	9: "nine",
	10: "ten",
}


func bottleCount(nBottle int) (string, error) {
	switch nBottle {
	case 0:
		return "no green bottles", nil
	case 1:
		return "one green bottle", nil
	default:
		if numberS, ok := numberString[nBottle]; !ok {
			return "", fmt.Errorf("don't know how to say number %v", nBottle)
		} else {
			return fmt.Sprintf("%v green bottles", numberS), nil
		}
	}
}

func reciteOne(startBottles int) []string {
	curBottles, _ := bottleCount(startBottles)
	nxtBottles, _ := bottleCount(startBottles - 1)
	return []string{
		fmt.Sprintf("%s hanging on the wall,", capitalize(curBottles)),
		fmt.Sprintf("%s hanging on the wall,", capitalize(curBottles)),
		"And if one green bottle should accidentally fall,",
		fmt.Sprintf("There'll be %s hanging on the wall.", nxtBottles),
	}
}

func Recite(startBottles, takeDown int) []string {
	out := []string{}
	for takeDown > 0 {
		out = append(out, reciteOne(startBottles)...)
		startBottles--
		takeDown--
		if takeDown > 0 {
			out = append(out, "")
		}
	}
	return out
}
