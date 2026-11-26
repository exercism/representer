Imports System

Public Module Gigasecond
    Public Function Add(ByVal moment As Date) As Date
        Return DateAdd(DateInterval.Second, 1000000000, moment)
    End Function
End Module
