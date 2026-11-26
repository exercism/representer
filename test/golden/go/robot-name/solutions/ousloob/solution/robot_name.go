// Package robotname contains functions ton manage names of robots.
package robotname

import (
	"errors"
	"fmt"
	"math/rand"
	"time"
)

var (
	// random is the new source of seed.
	random = rand.New(rand.NewSource(time.Now().UnixNano()))
	// botList record all the robot names already attributed.
	botList = map[string]bool{}
)

// Robot contains informations about a robot.
type Robot struct {
	ID string
}

// Name attribute a random name for a robot.
func (r *Robot) Name() (string, error) {
	if r.ID != "" {
		return r.ID, nil
	}

	if len(botList) == 26*26*10*10*10 {
		return "", errors.New("all names have been allocated")
	}

	r.ID = newName()
	for botList[r.ID] {
		r.ID = newName()
	}
	botList[r.ID] = true

	return r.ID, nil
}

// Reset reset a robot name.
func (r *Robot) Reset() {
	r.ID = ""
}

// NewName generate a random name for a robot.
func newName() string {
	r1 := random.Intn(26) + 'A'
	r2 := random.Intn(26) + 'A'
	num := random.Intn(1000)

	return fmt.Sprintf("%c%c%03d", r1, r2, num)
}
