class CollatzConjecture {
    enum CollatzConjectureError: Error {
        case negativeValueError
    }

    static func collatz(_ n: Int) -> Int {
        return n % 2 == 0 ? n / 2 : 3 * n + 1
    }

    static func steps(_ number: Int) throws -> Int {
        guard number > 0 else {
            throw CollatzConjectureError.negativeValueError
        }

        var n: Int = number
        var steps: Int = 0

        while n != 1 {
            steps += 1
            n = collatz(n)
        } 
        return steps
    }
}
