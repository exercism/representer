Public Class Allergies
    Private ReadOnly _allergyValue As Integer

    Public Sub New(allergyValue As Integer)
        _allergyValue = allergyValue
    End Sub

    Public Function AllergicTo(food As String) As Boolean
        Select Case food
            Case "eggs"
                Return _allergyValue And 1
            Case "peanuts"
                Return _allergyValue And 2
            Case "shellfish"
                Return _allergyValue And 4
            Case "strawberries"
                Return _allergyValue And 8
            Case "tomatoes"
                Return _allergyValue And 16
            Case "chocolate"
                Return _allergyValue And 32
            Case "pollen"
                Return _allergyValue And 64
            Case "cats"
                Return _allergyValue And 128
            Case Else
                Return False
        End Select
    End Function

    Public Function List() As IEnumerable(Of String)
        Dim possibleAllergies = New String() _
                {"eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"}
        Return possibleAllergies.Where((Function(allergy) AllergicTo(allergy)))
    End Function
End Class