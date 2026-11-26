Imports System

Public Module ArmstrongNumbers
    Public Function IsArmstrongNumber(ByVal number As Integer) As Boolean
        If number < 0 then
            Throw new ArgumentOutOfRangeException()
        End if
  
        Dim numStr = number.ToString()
        Dim sum As Integer = 0
    
        For Each c In numStr
            sum = sum + Math.Pow(char.GetNumericValue(c), numStr.Length)
        Next

        Return sum = number
    End Function
End Module
