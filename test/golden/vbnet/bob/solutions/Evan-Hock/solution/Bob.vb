Imports System.Runtime.CompilerServices

Module BobExtensions
    <Extension>
    Public Function IsQuestion(s As String) As Boolean
        Return RTrim(s).EndsWith("?"c)
    End Function

    <Extension>
    Public Function IsYelling(s As String) As Boolean
        Return _
            s.Any(Function(c) Char.IsLetter(c)) _
            AndAlso s.All(Function(c) Not Char.IsLetter(c) OrElse Char.IsUpper(c))
    End Function
End Module

Public Class Bob
    Private Const SilenceResponse = "Fine. Be that way!"
    Private Const QuestionResponse = "Sure."
    Private Const YellingResponse = "Whoa, chill out!"
    Private Const YellingQuestionResponse = "Calm down, I know what I'm doing!"
    Private Const StandardResponse = "Whatever."

    Public Function Hey(statement As String) As String
        If String.IsNullOrWhiteSpace(statement) Then
            Return SilenceResponse
        End If

        Dim question = statement.IsQuestion()
        Dim yelling = statement.IsYelling()
        If question And yelling Then
            Return YellingQuestionResponse
        ElseIf question Then
            Return QuestionResponse
        ElseIf yelling Then
            Return YellingResponse
        Else
            Return StandardResponse
        End If
    End Function
End Class