Imports System.Collections.Generic

Public Module MatchingBrackets
    Public Function IsPaired(ByVal input As String) As Boolean
        Dim queue as ArrayList = new ArrayList()
        For Each c as Char in input
            If c = "(" Or c = "[" Or c = "{" Then
                queue.Add(c)
            ElseIf c = ")" Then
                If queue.Count = 0 then
                    Return False
                End If
                If queue.Item(queue.Count-1) = "(" then
                    queue.RemoveAt(queue.Count-1)
                Else
                    Return False
                End If
            ElseIf c = "]" Then
                If queue.Count = 0 then
                    Return False
                End If
                If queue.Item(queue.Count-1) = "[" then
                    queue.RemoveAt(queue.Count-1)
                Else
                    Return False
                End If
            ElseIf c = "}" Then
                If queue.Count = 0 then
                    Return False
                End If
                If queue.Item(queue.Count-1) = "{" then
                    queue.RemoveAt(queue.Count-1)
                Else
                    Return False
                End If
            End If
        Next
        If queue.Count() = 0 then
            Return True
        Else
            Return False
        End If
    End Function
End Module