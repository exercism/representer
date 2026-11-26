Public Module DifferenceOfSquares
    Public Function CalculateSquareOfSum(ByVal max As Integer) As Integer
        'Gauss's formula for the sum of the first n natural numbers is n(n + 1) / 2
        Dim sum As Integer = (max * (max + 1)) \ 2
        Return sum ^ 2
    End Function

    Public Function CalculateSumOfSquares(ByVal max As Integer) As Integer
        'Formula for the sum of the squares of the first n natural numbers is n(n + 1)(2n + 1) / 6
        Return (max * (max + 1) * ((2 * max) - 1)) \ 6
    End Function

    Public Function CalculateDifferenceOfSquares(ByVal max As Integer) As Integer
        Return CalculateSquareOfSum(max) - CalculateSumOfSquares(max)
    End Function
End Module
