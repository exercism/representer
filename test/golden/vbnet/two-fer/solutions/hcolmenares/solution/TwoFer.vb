Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(Optional ByVal friendsName As String = "") As String
        If String.IsNullOrEmpty(friendsName) Then
            Return "One for you, one for me."
        Else
            Return "One for " & friendsName & ", one for me."
        End If
    End Function
End Module
