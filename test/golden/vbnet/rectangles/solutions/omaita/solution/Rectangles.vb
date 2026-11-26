Imports System

Public Module Rectangles

    Public Function Count(ByVal rows As String()) As Integer

        Dim numrows As Integer = rows.Length
        If numrows = 0 Then Return 0

        Dim numcols As Integer = rows(0).Length
        If numcols = 0 Then Return 0

        Dim points As New List(Of (Integer, Integer, Integer, Integer))
        Dim matrix(numrows, numcols) As Char
        Dim index, numrectangles As Integer
        Dim brokenRectangle As Boolean

        'Fill matrix array with "+", "-", "|", " "
        Dim aux = rows.Aggregate(Function(acc, s) acc & s)

        For r = 0 To numrows - 1
            For c = 0 To numcols - 1
                matrix(r, c) = aux(index)
                index += 1
            Next
        Next

        'Find all rectangles in grid
        For r = 0 To numrows - 2
            For c = 0 To numcols - 2
                For dr = r + 1 To numrows - 1
                    For dc = c + 1 To numcols - 1
                        points.Add((r, c, dr, dc))
                    Next
                Next
            Next
        Next

        'Test is valid rectangle or not
        'Item1 = top left row
        'Item2 = top left column
        'Item3 = bottom right row
        'Item4 = bottom right column
        For Each p In points

            brokenRectangle = False

            If matrix(p.Item1, p.Item2) = "+"c And matrix(p.Item1, p.Item4) = "+"c And matrix(p.Item3, p.Item2) = "+"c And matrix(p.Item3, p.Item4) = "+"c Then

                'Top row
                For column = p.Item2 + 1 To p.Item4 - 1
                    If matrix(p.Item1, column) = "|"c Or matrix(p.Item1, column) = " "c Then
                        brokenRectangle = True
                    End If
                Next
                If brokenRectangle Then Continue For

                'Bottom row
                For column = p.Item2 + 1 To p.Item4 - 1
                    If matrix(p.Item3, column) = "|"c Or matrix(p.Item3, column) = " "c Then
                        brokenRectangle = True
                    End If
                Next
                If brokenRectangle Then Continue For

                'Left column
                For row = p.Item1 + 1 To p.Item3 - 1
                    If matrix(row, p.Item2) = "-"c Or matrix(row, p.Item2) = " "c Then
                        brokenRectangle = True
                    End If
                Next
                If brokenRectangle Then Continue For

                'Right column
                For row = p.Item1 + 1 To p.Item3 - 1
                    If matrix(row, p.Item4) = "-"c Or matrix(row, p.Item4) = " "c Then
                        brokenRectangle = True
                    End If
                Next
                If brokenRectangle Then Continue For

                numrectangles += 1

            End If

        Next

        Return numrectangles

    End Function

End Module


