Imports System.Runtime.CompilerServices

''' <summary>
''' Extension methods for instances of <see cref="Int32"/>.
''' </summary>
<Extension>
Public Module Int32Extensions

    'Public Methods

    ''' <summary>
    ''' Returns the aliquot sum, that is the sum of all divisors of the given <paramref name="positiveNumber"/> except itself, 
    ''' e.g. 12 => 1 + 2 + 3 + 4 + 6 = 16. Only positive <see cref="Int32"/> are accepted, zero and negative values throw an
    ''' <see cref="ArgumentOutOfRangeException"/>. The result is returned as an UInt32 as it may be greater than <see cref="Int32.MaxValue"/>.
    ''' </summary>
    ''' <param name="positiveNumber">The value from which to return the aliquot sum.</param>
    ''' <returns>The aliquot sum of the given <paramref name="positiveNumber"/>.</returns>
    ''' <exception cref="ArgumentOutOfRangeException">An ArgumentOutOfRangeException is thrown if the given value is zero or negative.</exception>
    <Extension>
    Public Function GetAliquotSum(positiveNumber As Int32) As UInt32
        If (positiveNumber < 1) Then Throw New ArgumentOutOfRangeException(NameOf(positiveNumber), positiveNumber, $"A positive number expected!")
        If (positiveNumber = 1) Then Return 0
        Dim result As UInt32 = 1
        Dim sqrt As Int32 = IntSqrt(positiveNumber)
        For i As Int32 = 2 To sqrt
            Dim remainder As Int32
            Dim quotient As Int32 = Math.DivRem(positiveNumber, i, remainder)
            If (remainder = 0) Then
                result += i
                If (i <> quotient) Then result += quotient
            End If
        Next
        Return result
    End Function

    'Private Methods

    Private Function IntSqrt(positiveNumber As Int32) As Int32
        If (positiveNumber < 1) Then Throw New ArgumentOutOfRangeException(NameOf(positiveNumber), positiveNumber, $"A positive number expected!")
        Dim exactRoot As Double = Math.Sqrt(positiveNumber)
        Return CInt(Math.Truncate(exactRoot))
    End Function

End Module
