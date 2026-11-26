Imports System
Imports System.Collections.Generic

Public Module PrimeFactors

    Public Function Factors(number As Long) As Long()
    
        If number < 2 Then Return Array.Empty(Of Long)()

        Dim result As New List(Of Long)

        While (number And 1) = 0
            result.Add(2)
            number >>= 1
        End While

        Dim divisor As Long = 3

        While divisor <= number \ divisor AndAlso number > 1
            While number Mod divisor = 0
                result.Add(divisor)
                number \= divisor
            End While

            divisor += 2
        End While

        If number > 1 Then result.Add(number)

        Return result.ToArray()
        
    End Function

End Module
