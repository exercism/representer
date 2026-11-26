enum CollatzError: Error {
    case invalidNumber
}

class CollatzConjecture {
    static func steps(_ number: Int) throws -> Int {
        // Check if the input is valid (positive integer)
        guard number > 0 else {
            throw CollatzError.invalidNumber
        }
        
        // If the number is 1, return 0 steps
        if number == 1 {
            return 0
        }
        
        var currentNumber = number
        var stepCount = 0
        
        // Apply the Collatz Conjecture rules until we reach 1
        while currentNumber != 1 {
            if currentNumber % 2 == 0 {
                // If the number is even, divide by 2
                currentNumber /= 2
            } else {
                // If the number is odd, multiply by 3 and add 1
                currentNumber = currentNumber / 3 + 1
            }
            
            // Increment the step counter
            stepCount += 1
        }
        
        return stepCount
    }
}