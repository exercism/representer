Public Module TwoFer
    ' In order to get the tests running, first you need to make sure the Speak method 
    ' can be called both without any arguments and also by passing one string argument.
    Public Function Speak(optional byval name as string = nothing) As String
        if name is nothing then
          return "One for you, one for me."
        else
          return "One for " + name + ", one for me."
        end if
      
    End Function
End Module
