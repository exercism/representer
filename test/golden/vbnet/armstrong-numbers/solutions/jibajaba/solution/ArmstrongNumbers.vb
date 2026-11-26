Imports System

Public Module ArmstrongNumbers
  Public Function IsArmstrongNumber(number)
    
    Dim num = number, total = 0
    
    While (num > 0)
      total += (num mod 10)^(len(str(number))-1)
      num = num\10        
    End While

    return total = number

  End Function
End Module  

