import Foundation
struct Squares{
    let squareOfSum : Int
    let sumOfSquares : Int
    let differenceOfSquares : Int
    init(_ number:Int){
        var squareSum = 0
        var sumSquare = 0
        for n in 1...number {
            print(n)
            squareSum += n
            sumSquare += Int(pow(Double(n),2))
        }
        squareSum = Int(pow(Double(squareSum),2))
        squareOfSum = squareSum
        sumOfSquares = sumSquare
        differenceOfSquares = squareOfSum - sumOfSquares
    }
}