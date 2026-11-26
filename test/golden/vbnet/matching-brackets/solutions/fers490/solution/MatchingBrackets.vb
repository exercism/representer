Imports System.Collections.Generic

Public Module MatchingBrackets
    Public Function IsPaired(ByVal input As String) As Boolean
        Dim pairs As New Stack(Of Char)
        For Each c As Char In input.ToCharArray()
            If c = "("c Or c = "["c Or c = "{"c Then
                pairs.Push(c)
            ElseIf c = ")"c Then
              If pairs.Count = 0 OrElse pairs.Pop() <> "("c Then
                Return False
              End If
            ElseIf c = "]"c Then
              If pairs.Count = 0 OrElse pairs.Pop() <> "["c Then
                Return False
              End If
            ElseIf c = "}"c Then
              If pairs.Count = 0 OrElse pairs.Pop() <> "{"c Then
                Return False
              End If
            End If
        Next
        Return pairs.Count = 0
    End Function
End Module