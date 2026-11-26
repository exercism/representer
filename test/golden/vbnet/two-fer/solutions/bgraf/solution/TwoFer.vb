Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(Optional name As String = "you") As String
        Return String.Format("One for {0}, one for me.", name)
    End Function
End Module
