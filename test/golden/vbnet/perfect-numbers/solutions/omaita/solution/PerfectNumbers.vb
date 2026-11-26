Imports System
Imports System.Collections.Generic
Imports System.Linq

Public Enum Classification
    Perfect
    Abundant
    Deficient
End Enum

Public Module PerfectNumbers
  
    Public Function Classify(ByVal number As Integer) As Classification

        Dim sum As Integer
        Dim factor As Integer = 1

        If number <= 0 Then Throw New ArgumentOutOfRangeException

        While factor < number
            If number Mod factor = 0 Then
                sum += factor
            End If
            factor += 1
        End While

        If sum = number Then
            Return Classification.Perfect
        ElseIf sum > number Then
            Return Classification.Abundant
        Else
            Return Classification.Deficient
        End If

    End Function
    
End Module
