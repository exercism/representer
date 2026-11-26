Public Module Hamming
    Public Function Distance(ByVal firstStrand As String, ByVal secondStrand As String) As Integer
        If firstStrand.Length <> secondStrand.Length Then
            Throw New ArgumentException("Strands have different lengths")
        End If
        Dim result As integer
        For index = 0 To firstStrand.Length - 1
            If firstStrand(index) <> secondStrand(index) Then
              result = result + 1
            End If
        Next
        Return result
    End Function
End Module