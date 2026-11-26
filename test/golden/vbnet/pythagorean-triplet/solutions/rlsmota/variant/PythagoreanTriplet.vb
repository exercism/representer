Imports System
Imports System.Collections.Generic

Public Module PythagoreanTriplet
	Public Function TripletsWithSum(ByVal sum As Integer) As IEnumerable(Of (Integer, Integer, Integer))
		Dim result As New List(Of (Integer, Integer, Integer))()

		For a = 1 To sum \ 3
			For b = a To (sum - a) \ 2
				Dim c = sum - a - b
				If a * a + b * b = c / c Then
					result.Add((a, b, c))
				End If
			Next
		Next

		Return result
	End Function
End Module