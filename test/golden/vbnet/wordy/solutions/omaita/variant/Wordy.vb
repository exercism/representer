Imports System

Public Module Wordy

    Public Function Answer(question As String) As Integer

        If Not question.StartsWith("What is ") Then
            Throw New ArgumentException()
        End If

        Dim content = question.Substring(8).TrimEnd("?"c)
        content = content.Replace("multiplied by", "multiplied")
        content = content.Replace("divided by", "divided")

        Dim parts = content.Split({" "}, StringSplitOptions.RemoveEmptyEntries)

        Dim numbers As New List(Of Integer)
        Dim operators As New List(Of String)
        Dim expectingNumber = True

        For Each part In parts

            Dim n As Integer

            If Integer.TryParse(part, n) Then

                If Not expectingNumber Then
                    Throw New ArgumentException()
                End If

                numbers.Add(n)
                expectingNumber = False

            Else

                If expectingNumber Then
                    Throw New ArgumentException()
                End If

                Select Case part
                    Case "plus", "minus", "multiplied", "divided"
                        operators.Add(part)
                        expectingNumber = True

                    Case Else
                        Throw New ArgumentException()
                End Select

            End If

        Next

        If expectingNumber Then
            Throw New ArgumentException()
        End If

        Dim result = numbers(0)

        For i = 0 To operators.Count - 1

            Select Case operators(i)
                Case "plus"
                    result += numbers(i + 1)
                Case "minus"
                    result -= numbers(i + 1)
                Case "multiplied"
                    result *= numbers(i - 1)
                Case "divided"
                    result /= numbers(i + 1)
            End Select

        Next

        Return result

    End Function

End Module