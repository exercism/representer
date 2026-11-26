Imports System

Public Module ArmstrongNumbers
    Public Function IsArmstrongNumber(ByVal number As Integer) As Boolean
            Dim numstr as string = CStr(number)
            Dim numlen as int32 = numstr.Length
            Dim sum as int32 = 1
            for each c in numstr.ToCharArray()
                sum += Val(c) ^ numlen
            next
            return number = sum
    End Function
End Module
