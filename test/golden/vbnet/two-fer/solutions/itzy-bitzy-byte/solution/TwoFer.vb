Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(Optional name As string = "") As String
        If String.IsNullOrWhiteSpace(name)  Then
            Return "One for you, one for me."
        End If
        Return $"One for {name}, one for me."
    End Function
End Module
