Public Module Luhn

    Public Function IsValid(number As String) As Boolean

        Dim sum As Integer = 0
        Dim digitCount As Integer = 0
        Dim doubleDigit As Boolean = False

        For i As Integer = number.Length - 1 To 0 Step -1

            Dim c As Char = number(i)

            If Char.IsWhiteSpace(c) Then
                Continue For
            End If

            If Not Char.IsDigit(c) Then
                Return False
            End If

            Dim value As Integer = AscW(c) - AscW("0"c)

            If doubleDigit Then
                value *= 2

                If value > 9 Then
                    value -= 9
                End If
            End If

            sum += value
            digitCount += 1
            doubleDigit = Not doubleDigit

        Next

        Return digitCount >= 2 AndAlso sum Mod 10 = 0

    End Function

End Module