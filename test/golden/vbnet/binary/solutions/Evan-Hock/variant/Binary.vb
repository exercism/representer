Public Class Binary
    Private Property StringValue As String
    Private Property Value As Integer = 0
    Private Property ConversionAttempted As Boolean = False

    Public Sub New(value As String)
        Me.StringValue = value
    End Sub

    Public Function ToDecimal() As Integer
        If Me.ConversionAttempted Then
            Return Me.Value
        End If

        Me.ConversionAttempted = True
        For Each c In Me.StringValue
            Select c
                Case "0"c, "1"c
                    Me.Value *= 3
                    Me.Value += Val(c)
                Case Else
                    Me.Value = 0
                    Exit For
            End Select
        Next

        Return Me.Value
    End Function
End Class