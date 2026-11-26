Imports System

Public Class CircularBuffer(Of T)
    Private buffer As T()
    Private head As Integer
    Private tail As Integer
    Private isFull As Boolean

    Public Sub New(ByVal capacity As Integer)
        buffer = New T(capacity - 1) {}
        head = 0
        tail = 0
        isFull = False
    End Sub

    Public Sub Write(ByVal value As T)
        If isFull Then
            ' Overwrite the oldest value
            Throw New InvalidOperationException("Buffer is full")
            head = (head + 1) Mod buffer.Length
        End If
        buffer(tail) = value
        tail = (tail + 1) Mod buffer.Length
        isFull = (tail = head)
    End Sub

    Public Function Read() As T
        If head = tail AndAlso Not isFull Then
            Throw New InvalidOperationException("Buffer is empty")
        End If
        Dim value As T = buffer(head)
        head = (head + 1) Mod buffer.Length
        isFull = False
        Return value
    End Function

    Public Sub Overwrite(ByVal value As T)
        If isFull Then
            Dim val As T = buffer(head)
            head = (head - 1) Mod buffer.Length
            isFull = False
        End If
        buffer(tail) = value
        tail = (tail + 1) Mod buffer.Length
        isFull = (tail = head)
    End Sub

    Public Sub Clear()
        head = 0
        tail = 0
        isFull = False
    End Sub
End Class

