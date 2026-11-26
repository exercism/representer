Public Class HighScores
    Private _scores As List(Of Integer)    

    Public Sub New(ByVal scores As List(Of Integer))
        _scores = scores 
    End Sub

    Public Function Scores() As List(Of Integer)
        return _scores
    End Function

    Public Function Latest() As Integer
        return _scores.Last()
    End Function

    Public Function PersonalBest() As Integer
        return _scores.Max()
    End Function

    Public Function PersonalTopThree() As List(Of Integer)
        return _scores.OrderByDescending(Function (o) o).Take(3).ToList()
    End Function
End Class
