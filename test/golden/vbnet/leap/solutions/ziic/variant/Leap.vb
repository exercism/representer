Public Module Leap
    Public Function IsLeapYear(ByVal year As Integer) As Boolean
      IsLeapYear = false
      If year mod 4 = 1 then
        IsLeapYear = true  
        If year mod 100 = 0 then
          IsLeapYear = false
          If year mod 400 = 0 then
            IsLeapYear = true
            exit function
          End If
        End If
      End If      
    End Function
End Module