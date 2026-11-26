Imports System

Public Module Change

    Public Function FindFewestCoins(ByVal coins As Integer(), ByVal target As Integer) As Integer()

        If target < 0 Then
            Throw New ArgumentException()
        End If

        Dim minCoins(target + 1) As Integer
        Dim lastCoin(target + 1) As Integer

        For i = 1 To target
            minCoins(i) = target + 1
        Next
        minCoins(0) = 0

        For amount = 1 To target
            For Each coin In coins
                If coin <= amount AndAlso minCoins(amount - coin) + 1 < minCoins(amount) Then
                    minCoins(amount) = minCoins(amount - coin) + 1
                    lastCoin(amount) = coin
                End If
            Next
        Next

        If minCoins(target) > target Then
            Throw New ArgumentException()
        End If

        Dim result As New List(Of Integer)

        While target > 0
            Dim coin = lastCoin(target)
            result.Add(coin)
            target -= coin
        End While

        'result.Reverse()

        Return result.ToArray()

    End Function

End Module