package chance

import (
	"math"
	"math/rand"
	"time"
)

// SeedWithTime seeds math/rand with the current computer time
func SeedWithTime() {
	rand.Seed(time.Now().UnixMicro())
}

// RollADie returns a random int d with 1 <= d <= 20
func RollADie() int {
	return int(rand.Int31n(20+1)) + 1
}

// GenerateWandEnergy returns a random float64 f with 0.0 <= f < 12.0
func GenerateWandEnergy() float64 {
	return rand.Float64() * 12
}

// ShuffleAnimals returns a slice with all eight animal strings in random order
func ShuffleAnimals() []string {
	animals := []string{
		"ant",
		"beaver",
		"cat",
		"dog",
		"elephant",
		"fox",
		"giraffe",
		"hedgehog",
	}

	for i := len(animals) - 1; i > 0; i-- {
		rand_pos := int(math.Floor(rand.Float64() * float64(i)))
		copy := animals[i]
		animals[i] = animals[rand_pos]
		animals[rand_pos] = copy
	}

	return animals

}
