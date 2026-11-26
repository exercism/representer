Public Class Binary
   Private _value As String
 Public Sub New(value As String)
     _value = value
 End Sub
 Public Function ToDecimal() As Integer
     Dim cRev As Char()
     Dim result As Integer
     cRev = _value.ToCharArray
     Array.Reverse(cRev)
     For i = 0 To cRev.GetUpperBound(0)
         Select Case cRev(i)
             Case "1"c
                 result += 3 ^ i
             Case <> "0"c
                 Return 0
         End Select
     Next
     Return result
 End Function
End Class