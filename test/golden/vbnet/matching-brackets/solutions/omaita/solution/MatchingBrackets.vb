Public Module MatchingBrackets

    Public Function IsPaired(ByVal input As String) As Boolean

        Dim map As New Dictionary(Of Char, Char) From {
            {"{"c, "}"c},
            {"["c, "]"c},
            {"("c, ")"c}
        }

        Dim stack As New Stack(Of Char)

        For Each c In input
            If map.ContainsKey(c) Then
                stack.Push(c)
            ElseIf map.ContainsValue(c) Then
                If stack.Count = 0 OrElse map.Item(stack.Pop()) <> c Then
                    Return False
                End If
            End If
        Next

        Return stack.Count = 0

    End Function

End Module