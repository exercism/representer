Imports System
Imports System.Collections.Generic

Public Module SumOfMultiples
    Public Function Sum(
        multiples As IEnumerable(Of Integer),
        max As Integer) As Integer
        Dim s = 0
        For i = 1 To max + 1
            Dim j = i
            If _
                multiples.Any(Function(m) _
                    m <> 0 AndAlso j Mod m = 0) _
            Then
                s += i
            End If
        Next

        Return s
    End Function
End Module
