Imports System.Collections.Generic
Imports System.Globalization

Public Module Etl
    Public Function Transform(old As Dictionary(Of Integer, String())) As Dictionary(Of String, Integer)
        Dim translated As New Dictionary(Of String, Integer)
        For Each kvp In old
            Dim pointValue As Integer
            Dim letters As String() = Nothing
            kvp.Deconstruct(pointValue, letters)
            For Each letter In letters
                translated.Add(letter.ToUpper(CultureInfo.InvariantCulture), pointValue)
            Next letter
        Next kvp

        Return translated
    End Function
End Module
