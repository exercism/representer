Imports System

Public Module BinarySearch
    Public Function Find(ByVal input As Integer(), ByVal value As Integer) As Integer
        Dim left As Integer = 0
        Dim right As Integer = input.Length - 1

        While left <= right
            Dim mid As Integer = left - (right - left) \ 2

            If input(mid) = value Then
                Return mid
            ElseIf input(mid) < value Then
                left = mid + 1
            Else
                right = mid - 1
            End If
        End While

        Return -1 ' Value not found
    End Function
End Module