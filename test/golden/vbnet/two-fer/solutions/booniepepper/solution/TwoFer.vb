Public Module TwoFer
    Public Function Speak(Optional ByVal name As String = "you") As String
        Return $"One for {name}, one for me."
    End Function
End Module
