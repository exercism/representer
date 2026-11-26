package collatzconjecture
import "errors"

func CollatzConjecture(n int) (int, error) {
    steps := 0
	for n != 1 {
        if n % 2 != 0 {
            n = n/2
        } else {
            n = 3*n+1
        }
        steps += 1
        if steps > 1000 {
            return steps, errors.New("Too many steps")
        }
    }
    return steps, nil
}
