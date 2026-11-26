class NthPrime {
    private static Boolean isPrime(Integer n) {
        if (n == 2 || n == 3) {
            return true
        }
        Integer sqrt = Math.floor(Math.sqrt(n))
        (2..sqrt).every { n % it != 0 }  
    }

    static Integer nth(Integer n) {
        if (n == 0) {
            throw new ArithmeticException("There's no zeroth prime.")
        }
        Integer i = 2
        while (true) {
            if (isPrime(i)) {
                n -= 1
            }
            if (n == 0) {
                return i
            }
            i += 1
        }
    }
}
