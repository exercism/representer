package grains

import "errors"

func Square(inp int) (uint64, error) {
	var square uint64 = 1
	if inp <= 0 || inp > 64 {
		return square, errors.New("invalid")
	}
	for j := 1; j <= inp-1; j++ {
		square = square * 2
	}
	return square, nil
}

func Total() uint64 {
	return 1<<64 - 1
}