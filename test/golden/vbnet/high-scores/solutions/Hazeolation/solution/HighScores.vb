Imports System
Imports System.Collections.Generic
Imports System.Linq

Public Class HighScores
    Dim _list As List(Of Integer)
  
    Public Sub New(ByVal scores As List(Of Integer))
        _list = scores
    End Sub

    Public Function Scores() As List(Of Integer)
        Scores = _list   
    End Function

    Public Function Latest() As Integer
        Return _list.Last()
    End Function

    Public Function PersonalBest() As Integer
        Return _list.Max()
    End Function

    Public Function PersonalTopThree() As List(Of Integer)
        Dim _scores = _list.OrderDescending().ToList()
        If _scores.Count < 3 Then
            Return _scores
        Else
            Return _scores.GetRange(0, 3)
        End If

    End Function
End Class
