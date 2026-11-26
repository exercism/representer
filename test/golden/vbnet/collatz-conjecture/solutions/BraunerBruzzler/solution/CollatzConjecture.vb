Imports System
Imports System.ComponentModel.Design

Public Module CollatzConjecture
    Public Function Steps(ByVal number As Integer) As Integer

        If number < 1 Then
            Throw New ArgumentOutOfRangeException()
        End If

        Dim counter As Integer

        Do Until number = 1
            If number Mod 2 = 0 Then
                number = number / 2
            ElseIf number Mod 2 <> 0 Then
                number = number * 3 + 1
            End If
            counter = counter + 1
        Loop
        Return counter
    End Function
End Module