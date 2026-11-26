Public Class BinarySearchTree(Of T As IComparable(Of T))

    Private ReadOnly _data As T

    Public Sub New(ByVal data As T)
        _data = data
    End Sub

    Public ReadOnly Property Data As T
        Get
            Return _data
        End Get
    End Property

    Public Property Left As BinarySearchTree(Of T)

    Public Property Right As BinarySearchTree(Of T)

    Public Sub Insert(ByVal value As T)

        If Data.CompareTo(value) > 0 Then
            If Left Is Nothing Then
                Left = New BinarySearchTree(Of T)(value)
            Else
                Left.Insert(value)
            End If
        Else
            If Right Is Nothing Then
                Right = New BinarySearchTree(Of T)(value)
            Else
                Right.Insert(value)
            End If
        End If

    End Sub

    Public Function SortedData() As IEnumerable(Of T)

        Dim result As New List(Of T)

        If Left IsNot Nothing Then
            result.AddRange(Left.SortedData())
        End If

        result.Add(Data)

        If Right IsNot Nothing Then
            result.AddRange(Right.SortedData())
        End If

        Return result

    End Function

End Class
