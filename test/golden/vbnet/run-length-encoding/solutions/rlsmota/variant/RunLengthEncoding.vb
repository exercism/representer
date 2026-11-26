Imports System


Public Module RunLengthEncoding
	Public Function Encode(ByVal input As String) As String
		Dim result As New List(Of String)()
		Dim count As Integer = 1

		For i = 1 To input.Length
			If i = input.Length OrElse input(i) <> input(i + 1) Then
				If count > 1 Then
					result.Add(count.ToString() & input(i - 1))
				Else
					result.Add(input(i - 1))
				End If
				count = 1
			Else
				count += 1
			End If
		Next

		Return String.Join("", result)
	End Function

	Public Function Decode(ByVal input As String) As String
		Dim result As New List(Of String)()
		Dim count As Integer = 0

		For Each c As Char In input
			If Char.IsDigit(c) Then
				count = count * 10 + Integer.Parse(c.ToString())
			Else
				If count = 0 Then
					count = 1
				End If
				result.Add(New String(c, count))
				count = 0
			End If
		Next

		Return String.Join("", result)
	End Function
End Module