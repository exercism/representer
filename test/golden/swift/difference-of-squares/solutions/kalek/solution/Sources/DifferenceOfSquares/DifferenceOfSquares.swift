class Squares {
    let n: Int
    
    required init(_ n: Int) {
        self.n = n
    }
    
    private(set) lazy var sumOfSquares: Int = {
        var sumOfSquares = 0
        
        for i in 1...n {
            sumOfSquares += (i * i)
        }
        
        return sumOfSquares
    }()
    
    private(set) lazy var squareOfSum: Int = {
        var sum = 0
        
        for i in 1...n {
            sum += i
        }
        
        return sum * sum
    }()
    
    private(set) lazy var differenceOfSquares: Int = {
        return sumOfSquares > squareOfSum ? sumOfSquares - squareOfSum : squareOfSum - sumOfSquares
    }()
}