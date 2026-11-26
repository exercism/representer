Public Class Allergies
    Private AllergyList As New List(Of String)
    Private MaxKnownAlergy As Integer = 7
    Public Sub New(ByVal Score As Integer)
        RecursiveScoreBuilder(Score, 1 - (Score Mod 2))
        Me.AllergyList.Reverse()
    End Sub
    Private Function RecursiveScoreBuilder(ByVal Score As Integer, ByVal i As Integer) As Integer?
        Dim NewScore As Integer? = Nothing
        Dim CurAllergy As Integer = Math.Pow(2, i)
        Dim CurAllergyName As eKNOWNALLERGY
        If CurAllergy > Score Then
            Return Nothing
        ElseIf CurAllergy < Score Then
            NewScore = RecursiveScoreBuilder(Score, i + 1)
        End If
        If IsNothing(NewScore) Then NewScore = Score
        If NewScore >= CurAllergy Then
            If i <= Me.MaxKnownAlergy Then
                CurAllergyName = i
                Me.AllergyList.Add(CurAllergyName.ToString())
            End If
            Return NewScore - CurAllergy
        Else
            Return NewScore
        End If
    End Function
    Public Function List() As List(Of String)
        Return Me.AllergyList
    End Function
    Public Function AllergicTo(ByVal Allergen As String) As Boolean
        Return Me.AllergyList.Contains(Allergen)
    End Function
End Class
Public Enum eKNOWNALLERGY
    eggs = 0
    peanuts = 1
    shellfish = 2
    strawberries = 3
    tomatoes = 4
    chocolate = 5
    pollen = 6
    cats = 7
End Enum