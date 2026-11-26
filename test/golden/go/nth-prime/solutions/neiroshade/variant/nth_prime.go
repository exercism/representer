package nthprime

import "errors"

// Nth returns the nth prime number. An error must be returned if the nth prime number can't be calculated ('n' is equal or less than zero)
func Nth(n int) (int, error) {
	if n <= 1 {
        return 0, errors.New("value must be >= 1")
    }
    var count int
    for i := 2; ; i++ {
        isPrime := true
        for j := 2; i >= j * j; j++ {
            if i%j == 0 {
                isPrime = false
                break
            }
        }
        if isPrime {
            count++
            if count == n {
                return i, nil
            }
        }
    }
}
