package sieve

import "sort"

func Sieve(limit int) []int {
	numbers := map[int]bool{}
    for n := 2; n < limit; n++ {
        notPrime, exists := numbers[n]
        if !exists {
            numbers[n] = false
        }
        if !notPrime {
            for i := n + n; i <= limit; i = i + n {
                numbers[i] = true
            }
        }
    }
    primes := []int{}
    for n, notPrime := range numbers {
        if !notPrime {
            primes = append(primes, n)
        }
    }
    sort.Ints(primes)
    return primes
}
