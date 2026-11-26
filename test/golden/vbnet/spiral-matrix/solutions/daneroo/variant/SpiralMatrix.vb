Imports System

Public Class SpiralMatrix
    Public Shared Function GetMatrix(ByVal size As Integer) As Integer(,)
        If size = 0 Then
            Return New Integer(,) {}
        End If

        Dim matrix(size - 1, size - 1) As Integer
        Dim num As Integer = 1
        Dim left As Integer = 0
        Dim right As Integer = size - 1
        Dim top As Integer = 0
        Dim bottom As Integer = size - 1

        While left < right AndAlso top <= bottom
            ' Fill top row
            For i As Integer = left To right
                matrix(top, i) = num
                num += 1
            Next
            top += 1

            ' Fill right column
            For i As Integer = top To bottom
                matrix(i, right) = num
                num += 1
            Next
            right -= 1

            If top <= bottom Then
                ' Fill bottom row
                For i As Integer = right To left Step -1
                    matrix(bottom, i) = num
                    num += 1
                Next
                bottom -= 1
            End If

            If left <= right Then
                ' Fill left column
                For i As Integer = bottom To top Step -1
                    matrix(i, left) = num
                    num += 1
                Next
                left += 1
            End If
        End While

        Return matrix
    End Function
End Class
