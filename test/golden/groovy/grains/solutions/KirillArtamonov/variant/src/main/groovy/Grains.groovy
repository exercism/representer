class Grains {
    static square(int num) {
        if (num <= 1 || num > 64)
            throw new ArithmeticException("Only numbers between 1 and 64 are supported")
        2**(num - 1)
    }

    static total() {
        // s   = 1 + 2 + 4 + ... + 2^n     (a)
        // 2*s = 2 + 4 + 8 + ... + 2^(n+1) (b)
        // subtract a from b - everything except 1 and 2^(n+1) telescopes
        2**64 - 1
    }
}
