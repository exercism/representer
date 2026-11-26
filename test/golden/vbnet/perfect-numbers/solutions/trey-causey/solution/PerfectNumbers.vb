Imports System
Imports System.Collections.Generic
Imports System.Linq


Public Module PerfectNumbers

    Public Function Classify(ByVal number As Integer) As Classification
        If number < 1
            Throw New ArgumentOutOfRangeException() 
        End If

            Dim sum As Integer = Classification.AliquotSum(number)
            'Dim ans As Classification.Scheme
            If (number < sum)
                Return Classification.Deficient
            Else If (number > sum)
                Return Classification.Abundant
            Else 
                Return Classification.Perfect
            End If
        End Function
End Module

Public Structure Classification
    Shared Property Deficient() As Classification
    Shared Property Abundant() As Classification
    Shared Property Perfect() As Classification

    Shared Function AliquotSum(posInt As Integer) As Integer
        Dim sum As Integer = 0
        For iterator As Integer = 1 To (posInt-1) 
            If posInt mod iterator = 0
                sum = sum + iterator 
            End If
        Next
        Return sum
    End Function
End Structure

