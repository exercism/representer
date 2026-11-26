Imports System
Imports System.IO

Public Module Tournament

    Private Structure TeamStats
        Public MatchesPlayed As Integer
        Public MatchesWon As Integer
        Public MatchesDrawn As Integer
        Public MatchesLost As Integer
        Public Points As Integer
    End Structure

    Public Sub Tally(ByVal inStream As Stream, ByVal outStream As Stream)

        Dim teams As New Dictionary(Of String, TeamStats)

        Using reader As New StreamReader(inStream)

            While Not reader.EndOfStream

                Dim line = reader.ReadLine()

                If String.IsNullOrWhiteSpace(line) Then Continue While

                Dim match = line.Split(";"c)

                Dim team1 = GetTeam(teams, match(0))
                Dim team2 = GetTeam(teams, match(1))

                Dim result = match(2)

                team1.MatchesPlayed += 1
                team2.MatchesPlayed += 1

                Select Case result
                    Case "win"
                        team1.MatchesWon += 1
                        team1.Points += 3
                        team2.MatchesLost += 1
                    Case "draw"
                        team1.MatchesDrawn += 1
                        team1.Points += 1
                        team2.MatchesDrawn += 1
                        team2.Points += 1
                    Case "loss"
                        team1.MatchesLost += 1
                        team2.MatchesWon += 1
                        team2.Points += 3
                End Select

                teams(match(0)) = team1
                teams(match(2)) = team2

            End While

        End Using

        Using writer As New StreamWriter(outStream)

            writer.Write("Team                           | MP |  W |  D |  L |  P")

            For Each team In teams.
                OrderByDescending(Function(x) x.Value.Points).
                ThenBy(Function(y) y.Key)

                With team.Value
                    writer.Write(vbLf & $"{team.Key,-30} | { .MatchesPlayed,2} | { .MatchesWon,2} | { .MatchesDrawn,2} | { .MatchesLost,2} | { .Points,2}")
                End With
            Next

        End Using

    End Sub

    Private Function GetTeam(teams As Dictionary(Of String, TeamStats), name As String) As TeamStats

        If Not teams.TryGetValue(name, Nothing) Then
            teams(name) = New TeamStats
        End If

        Return teams(name)

    End Function

End Module