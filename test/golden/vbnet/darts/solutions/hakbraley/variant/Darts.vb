Imports System

Public Module Darts  
  Public Function Score(ByVal x As Double, ByVal y As Double) As Integer
    Dim distance = Math.Sqrt(x*x + y*y)

    If distance <= 1
      Return 10
    ElseIf distance < 5
      Return 5
    ElseIf distance <= 10
      Return 1
    Else
      Return 0
    End If
  End Function
End Module
