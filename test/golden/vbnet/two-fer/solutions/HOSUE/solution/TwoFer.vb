Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(optional ByVal name As String = "") 

    if name = "" then 
      return  "One for you, one for me."

    else
      return   "One for "+name+", one for me."
    end if
    Throw New NotImplementedException("You need to implement this function.")
    End Function
End Module
