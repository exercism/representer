Public Module Atbash

    Private ReadOnly cifra As New Dictionary(Of String, String) From {
        {"a", "z"},
        {"b", "y"},
        {"c", "x"},
        {"d", "w"},
        {"e", "v"},
        {"f", "u"},
        {"g", "t"},
        {"h", "s"},
        {"i", "r"},
        {"j", "q"},
        {"k", "p"},
        {"l", "o"},
        {"m", "n"},
        {"n", "m"},
        {"o", "l"},
        {"p", "k"},
        {"q", "j"},
        {"r", "i"},
        {"s", "h"},
        {"t", "g"},
        {"u", "f"},
        {"v", "e"},
        {"w", "d"},
        {"x", "c"},
        {"y", "b"},
        {"z", "a"}
    }

    Public Function Encode(arg As String) As String

        Dim limpo As String = arg.ToLower()
        Dim textoLimpo As String = ""
        Dim transformed As String = ""

        ' Remove tudo que não for letra ou número
        For Each c As Char In limpo
            If Char.IsLetterOrDigit(c) Then
                textoLimpo &= c
            End If
        Next

        ' Aplica a cifra
        For Each c As Char In textoLimpo
            If Char.IsLetter(c) Then
                transformed &= cifra(c.ToString())
            ElseIf Char.IsDigit(c) Then
                transformed &= c
            End If
        Next

        ' Agrupa de 5 em 5
        Dim grupo As String = ""
        Dim count As Integer = 0

        For Each c As Char In transformed
            If count = 5 Then
                grupo &= " "
                count = 1
            End If

            grupo &= c
            count += 1
        Next

        Return grupo

    End Function

    Public Function Decode(arg As String) As String

        Dim limpo As String = arg.Replace(" ", "")
        Dim transformed As String = ""

        For Each c As Char In limpo
            If Char.IsLetter(c) Then
                transformed &= cifra(c.ToString())
            ElseIf Char.IsDigit(c) Then
                transformed &= c
            End If
        Next

        Return transformed

    End Function

End Module