	Public Class Allergies
		Private Enum Elem
			eggs = 1
			peanuts = 2
			shellfish = 4
			strawberries = 8
			tomatoes = 16
			chocolate = 32
			pollen = 64
			cats = 128
		End Enum
		Dim _bits As Integer
		Dim _list As New List(Of String)
		Public Sub New(bits As Integer)
			_bits = bits
			GetList()
		End Sub
		Private Sub GetList()
			Dim items As Array
			items = System.Enum.GetValues(GetType(Elem))
			For Each item In items
				If _bits And item Then
					_list.Add(System.Enum.GetName(GetType(Elem), item))
				End If
			Next
		End Sub
		Friend Function AllergicTo(v As String) As Boolean
			Return _list.Contains(v)
		End Function
		Public Function List() As List(Of String)
			Return _list
		End Function
	End Class