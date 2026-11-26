Imports System.Text

Public Class SimpleCipher

    Private ReadOnly _key As String

    Public Sub New()

        Dim rnd As New Random()
        Dim sb As New StringBuilder()

        For i As Integer = 1 To 100
            sb.Append(ChrW(rnd.Next(AscW("a"c), AscW("z"c) + 1)))
        Next

        _key = sb.ToString

    End Sub

    Public Sub New(ByVal key As String)
        _key = key
    End Sub

    Public ReadOnly Property Key As String
        Get
            Return _key
        End Get
    End Property

    Public Function Encode(ByVal plaintext As String) As String

        Dim sb As New StringBuilder(plaintext.Length)

        For i As Integer = 0 To plaintext.Length - 1
            Dim shift = AscW(_key(i Mod _key.Length)) - AscW("a"c)
            sb.Append(Rotate(plaintext(i), shift))
        Next

        Return sb.ToString()

    End Function

    Public Function Decode(ByVal ciphertext As String) As String

        Dim sb As New StringBuilder(ciphertext.Length)

        For i As Integer = 0 To ciphertext.Length - 1
            Dim shift = AscW(_key(i Mod _key.Length)) - AscW("a"c)
            sb.Append(Rotate(ciphertext(i), -shift))
        Next

        Return sb.ToString()

    End Function

    Private Function Rotate(c As Char, shiftKey As Integer) As Char

        Dim result = (AscW(c) - AscW("a"c) + shiftKey) Mod 26

        If result < 0 Then result += 26

        Return ChrW(result + AscW("a"c))

    End Function

End Class