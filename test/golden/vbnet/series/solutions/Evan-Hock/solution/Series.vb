Imports System.Collections.Generic

Public Module Series
    Public Function Slices(numbers As String, sliceLength As Integer) As String()
        If String.IsNullOrEmpty(numbers) Then
            Throw New ArgumentException(NameOf(numbers), "String cannot be empty")
        End If

        If sliceLength < 1 OrElse sliceLength > Len(numbers) Then
            Throw New ArgumentException(NameOf(sliceLength), $"Slice length must be in the range [1, Len({NameOf(numbers)})]")
        End If

        Dim n = Len(numbers) - sliceLength + 1
        Dim sliceList As New List(Of String)(n)
        For i = 1 To n
            sliceList.Add(Mid(numbers, i, sliceLength))
        Next

        Return sliceList.ToArray()
    End Function
End Module
