package collatzconjecture
import "errors"
func CollatzConjecture(n int) (int, error) {
	// panic("Please implement the CollatzConjecture function")
    if n <= 0 {
		return 0, errors.New("input must be a positive integer")
	}

    steps := 0

    for n != 1{
        if n%2 == 0{
            n = n/2
        }else{
        n= 3*n +1
        }
    steps ++
    }
return steps, nil
}
