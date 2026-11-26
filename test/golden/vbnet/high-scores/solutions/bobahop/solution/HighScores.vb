Public Class HighScores

    Private ReadOnly _scores As New List(Of Integer)
    Public Sub New(scores As List(Of Integer))
        _scores.AddRange(scores)
    End Sub

    Public Function Scores() As List(Of Integer)
        Dim output As New List(Of Integer)
        output.AddRange(_scores)
        Return output
    End Function

    Public Function Latest() As Integer
        Return _scores.Last
    End Function

    Public Function PersonalBest() As Integer
        Return _scores.Max
        ' or
        ' Return PersonalTopThree().First
    End Function

    Public Function PersonalTopThree() As List(Of Integer)
        Return _scores.OrderByDescending(Function(score) score).Take(3).ToList()
    End Function
End Class
