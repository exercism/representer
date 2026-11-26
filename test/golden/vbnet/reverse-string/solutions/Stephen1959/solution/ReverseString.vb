Public Module ReverseString
    Public Function Reverse(ByVal inputString As String) As String
        Dim revString As String
        revString = StrReverse(inputString)
        Return revString
    End Function
End Module
