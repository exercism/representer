Public Module ReverseString
    Public Function Reverse(ByVal inputString As String) As String

        If String.IsNullOrEmpty(inputString) Then
            Return inputString
        End If
        Dim Result As String = StrReverse(inputString)
        Return Result
    End Function
End Module
