Public Class Bob
    Private Shared ReadOnly answers = New String() {"Whatever.", "Sure.", "Whoa, chill out!", "Calm down, I know what I'm doing!"}
  
    Public Shared Function Hey(statement As String) As String
        Dim inp = statement.TrimEnd()
        If inp = "" Then Return "Fine. Be that way!"
        Dim isQuestion = If((inp.EndsWith("?")), 1, 0)
        Dim isShout = If((inp.Any(Function(c) Char.IsLetter(c)) AndAlso inp.ToUpper = inp), 2, 0)
        Return answers(isShout - isQuestion)
    End Function
End Class