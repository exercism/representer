Imports System
Imports System.Collections.Generic

Public Module SaddlePoints

    Public Function Calculate(ByVal matrix As Integer(,)) As IEnumerable(Of (Integer, Integer))

        Dim rows = matrix.GetLength(0)
        Dim cols = matrix.GetLength(1)

        Dim rowMax = Enumerable.Range(0, rows).
                        Select(Function(r) Enumerable.Range(0, cols).
                        Max(Function(c) matrix(r, c))).
                        ToArray()

        Dim colMin = Enumerable.Range(0, cols).
                        Select(Function(c) Enumerable.Range(0, rows).
                        Min(Function(r) matrix(r, c))).
                        ToArray()

        Return From r In Enumerable.Range(0, rows)
               From c In Enumerable.Range(0, cols)
               Where matrix(r, c) = rowMax(r) AndAlso
                     matrix(r, c) = colMin(c)
               Select (r + 1, c + 1)

    End Function

End Module