Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(Optional name As String = "") As String
        If name = "" then
            return "One for you, one for me."
        End If
        return "One for " & name & ", one for me."
    End Function
End Module
