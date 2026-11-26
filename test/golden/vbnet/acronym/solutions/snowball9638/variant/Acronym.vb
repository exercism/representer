Imports System
Imports System.Text.RegularExpressions


Public Module Acronym
    Public Function Abbreviate(ByVal phrase As String) As String
Return String.Join("", Regex.Matches(phrase.Replace("-", " ").Replace("_", " "), "\b[\w']+\b").Cast(Of Match)().Select(Function(m) m.Value(1))).ToUpper
      
    End Function
End Module
