Imports System

Public Module SquareRoot
    Public Function SquareRoot(ByVal radicand As Integer)
        If radicand < 2 Then
            Return radicand
        End If

        Dim x0 As Integer = radicand \ 2
        Dim x1 As Integer = (x0 + radicand \ x0) \ 2

        While x1 < x0
            x0 = x1
            x1 = (x0 + radicand \ x0) \ 2
        End While
        Return x0
    End Function
End Module