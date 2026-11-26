Imports System

Public Module Triangle
  
    Public Function IsScalene(ByVal side1 As Double, ByVal side2 As Double, ByVal side3 As Double) As Boolean
        If IsTriangle(side1, side2, side3) Then
            Return side1 <> side2 And side1 <> side3 And side2 <> side3
        Else
            Return False
        End If
    End Function

    Public Function IsIsosceles(ByVal side1 As Double, ByVal side2 As Double, ByVal side3 As Double) As Boolean
        If IsTriangle(side1, side2, side3) Then
            Return side1 = side2 Or side1 = side3 Or side2 = side3
        Else
            Return False
        End If
    End Function

    Public Function IsEquilateral(ByVal side1 As Double, ByVal side2 As Double, ByVal side3 As Double) As Boolean
        If IsTriangle(side1, side2, side3) Then
            Return side1 = side2 And side2 = side3
        Else
            Return False
        End If
    End Function

    Private Function IsTriangle(ByVal side1 As Double, ByVal side2 As Double, ByVal side3 As Double) As Boolean
        If side1 = 0 Or side2 = 0 Or side3 = 0 Then Return False
        Return side1 + side2 >= side3 And side1 + side3 >= side2 And side2 + side3 >= side1
    End Function

End Module
