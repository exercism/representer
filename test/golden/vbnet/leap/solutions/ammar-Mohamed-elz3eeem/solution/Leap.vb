Public Module Leap
    Public Function IsLeapYear(ByVal year As Integer) As Boolean
        If year Mod 4 = 0 Then
            If year Mod 100 = 0 Then
                If year Mod 400 = 0 Then
                    Return True
                End If
            Else
                Return True
            End If
        End If
        Return False
    End Function
End Module