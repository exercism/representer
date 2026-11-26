Imports System


Public Module House
	Dim verses As New Dictionary(Of Integer, String) From {
			{1, "the house that Jack built."},
			{2, "the malt that lay in"},
			{3, "the rat that ate"},
			{4, "the cat that killed"},
			{5, "the dog that worried"},
			{6, "the cow with the crumpled horn that tossed"},
			{7, "the maiden all forlorn that milked"},
			{8, "the man all tattered and torn that kissed"},
			{9, "the priest all shaven and shorn that married"},
			{10, "the rooster that crowed in the morn that woke"},
			{11, "the farmer sowing his corn that kept"},
			{12, "the horse and the hound and the horn that belonged to"}
		}
	Public Function Recite(ByVal verseNumber As Integer) As String
		Return "This is " & String.Join(" ", verses.Values.Take(verseNumber).Reverse())
	End Function

	Public Function Recite(ByVal startVerse As Integer, ByVal endVerse As Integer) As String
		Dim result As String = ""
		For i = startVerse To endVerse
			result &= If(result = "", "", vbLf) & Recite(i)
		Next


		Return result
	End Function
End Module
