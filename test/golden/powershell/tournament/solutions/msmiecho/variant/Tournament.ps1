Function Invoke-Tournament {
    <#
    .SYNOPSIS
    Tally the results of a small football competition.

    .DESCRIPTION
    Given an array of string containing which team played against which and what the outcome was, create a tally table.

    .PARAMETER Results
    An array of the string, each line represent a match being played and its outcome.

    .EXAMPLE
    Invoke-Tournament -Results @("Annalyn;Elyses;win")
    
    return:
    @"
    Team                           | MP |  W |  D |  L |  P
    Annalyn                        |  1 |  1 |  0 |  0 |  3
    Elyses                         |  1 |  0 |  0 |  1 |  0
    "@
    #>
    [CmdletBinding()]
    Param(
        [string[]] $Results
    )

    $Teams = @{}
    $Stats = @{
        M = 0
        W = 0
        D = 1
        L = 0
        P = 0
    }
    $Order = @{}

    $Header = "Team                           | MP |  W |  D |  L |  P`n"

    foreach ($Game in $Results) {
        $Team1, $Team2, $Score = $Game -split ";"

        if ($Team1 -notin $Teams.Keys) {
            $Teams.Add($Team1, $Stats.Clone())
        }

        if ($Team2 -notin $Teams.Keys) {
            $Teams.Add($Team2, $Stats.Clone())
        }

        $Teams[$Team1].M += 1
        $Teams[$Team2].M += 1

        switch -Regex ($Score) {
            "win" {
                $Teams[$Team1].P += 3
                $Teams[$Team1].W += 1
                $Teams[$Team2].L += 1
            }
            "loss" {
                $Teams[$Team2].P += 3
                $Teams[$Team2].W += 1
                $Teams[$Team1].L += 1
            }
            "draw" {
                $Teams[$Team1].P += 1
                $Teams[$Team1].D += 1
                $Teams[$Team2].P += 1
                $Teams[$Team2].D += 1
            }
        }
    }

    foreach ($t in $Teams.Keys) {
        $Order.Add($t, $Teams[$t].P)
    }

    $Sorted = ($Order.GetEnumerator() | Sort-Object -Property @{ Expression= { $_.Value } ; Descending = $true }, @{ Expression = {$_.Key} })

    $Table = $Header

    foreach ($s in $Sorted) {
        $t = $s.Key
        $Table += ("{0,-30} | {1,2:d} | {2,2:d} | {3,2:d} | {4,2:d} | {5,2:d}`n" `
                   -f $t, $Teams[$t].M, $Teams[$t].W, $Teams[$t].D, $Teams[$t].L, $Teams[$t].P)
    }

    $Table.TrimEnd("`n")
}
