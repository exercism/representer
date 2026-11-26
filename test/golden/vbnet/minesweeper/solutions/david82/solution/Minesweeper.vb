Imports System

Public Module Minesweeper
    Public Function Annotate(ByVal input As String()) As String()
        Return Enumerable.Range(0, input.Length) _
            .Select(Function(i)
                        Dim row = input(i)
                        Return String.Concat(Enumerable.Range(0, row.Length) _
                            .Select(Function(j) If(row(j) = "*", "*", GetMineCount(i, j, input))))
                    End Function) _
            .ToArray()
    End Function
    
    Private Function GetMineCount(row As Integer, column As Integer, input As String()) As Char
        Dim count = New List(Of (Row As Integer, Column As Integer)) From
            {(row - 1, column - 1), (row - 1, column), (row - 1, column + 1),
             (row, column - 1), (row, column + 1),
             (row + 1, column - 1), (row + 1, column), (row + 1, column + 1)} _
            .Select(Function(cell) CellToValue(cell.Row, cell.Column, input)) _
            .Sum()
        
        Return If(count = 0, " "c, ChrW(AscW("0") + count))
    End Function
    
    Private Function CellToValue(row As Integer, column As Integer, input As String()) As Integer
        If row < 0 OrElse row >= input.Length OrElse column < 0 OrElse column >= input(0).Length Then
            Return 0
        End If
        
        Return If(input(row)(column) = "*", 1, 0)
    End Function
End Module
