Imports System.Text

Public Module Minesweeper
  
    Public Function Annotate(ByVal input As String()) As String()

        If input.Length = 0 Then Return Array.Empty(Of String)

        Dim sb As New StringBuilder
        Dim index, minescounter As Integer
        Dim maxrow As Integer = input.Length - 1
        Dim maxcol As Integer = input(0).Length - 1

        'Fill array with " " and "*"
        Dim matrix(maxrow + 1, maxcol + 1) As String

        Dim aux = input.Aggregate(Function(acc, s) acc & s)

        For r As Integer = 0 To maxrow
            For c As Integer = 0 To maxcol
                matrix(r, c) = aux(index)
                index += 1
            Next
        Next

        'Count mines "*" adjacents to " " and append to sb
        For row As Integer = 0 To maxrow
            For col As Integer = 0 To maxcol
                If matrix(row, col) = " " Then
                    For r As Integer = Math.Max(0, row - 1) To Math.Min(maxrow, row + 1)
                        For c As Integer = Math.Max(0, col - 1) To Math.Min(maxcol, col + 1)
                            If matrix(r, c) = "*" Then
                                minescounter += 1
                            End If
                        Next
                    Next
                    If minescounter > 0 Then
                        sb.Append(minescounter)
                    Else
                        sb.Append(matrix(row, col))
                    End If
                    minescounter = 0
                Else
                    sb.Append(matrix(row, col))
                End If
            Next
        Next

        Return Enumerable.Range(0, maxrow + 1).Select(Function(c) sb.ToString.Substring(c * (maxcol + 1), maxcol + 1)).ToArray

    End Function

End Module
