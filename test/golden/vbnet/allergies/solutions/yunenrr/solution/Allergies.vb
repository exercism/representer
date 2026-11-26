Imports System.Collections.Generic

Public Class Allergies
    Private Property Allergies As Dictionary(Of Integer, String)
    Private Property thePersonScore As Integer
    Private Property PersonAllergies As List(Of String)
    
    Public Sub New(score As Integer)
      thePersonScore = score
      InitializeTheAllergies()
      PersonAllergies = New List(Of String)
      CalculateAllergies()
    End Sub

    Public Function AllergicTo(allergy As String) As Boolean
      Return PersonAllergies.Any(Function(theAllergy) theAllergy.Equals(allergy))
    End Function

    Public Function List() As IList(Of String)
      Return PersonAllergies
    End Function

    Private Sub CalculateAllergies()
      For Each theAllergy As KeyValuePair(Of Integer, String) In Allergies
          If IsAllergic(theAllergy.Key) Then
            PersonAllergies.Add(theAllergy.Value)
          End If
      Next
    End Sub

    Private Function IsAllergic(theValue) As Boolean
        Return theValue > 0 AndAlso (thePersonScore AND theValue) > 0
    End Function

    Private Sub InitializeTheAllergies()
      Allergies = New Dictionary(Of Integer, String)
      Allergies.Add(1, "eggs")
      Allergies.Add(2, "peanuts")
      Allergies.Add(4, "shellfish")
      Allergies.Add(8, "strawberries")
      Allergies.Add(16, "tomatoes")
      Allergies.Add(32, "chocolate")
      Allergies.Add(64, "pollen")
      Allergies.Add(128, "cats")
    End Sub

    Function GetKeyByValue(theValue As String) As Integer
        Return Allergies.FirstOrDefault(Function(kvp) kvp.Value = theValue).Key
    End Function
End Class