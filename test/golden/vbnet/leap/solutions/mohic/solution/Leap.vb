Public Module Leap
    Public Function IsLeapYear(ByVal year As Integer) As Boolean
        If year Mod 4 <> 0 Then
            return false
        end if

        If year Mod 400 = 0 Then
            return true
        end if

        If year Mod 100 = 0 Then
            return false
        end if

        return true
    End Function
End Module