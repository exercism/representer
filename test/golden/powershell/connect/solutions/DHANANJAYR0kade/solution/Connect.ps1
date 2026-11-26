<#
.SYNOPSIS
    Compute the result for a game of Hex / Polygon.

.DESCRIPTION
    Your goal is to build a program that given a simple representation of a board computes the winner (or lack thereof).
    Note that all games need not be "fair".
    Player 'O' plays from top to bottom, and player 'X' plays from left to right.
    
.EXAMPLE
    $board = @(
        "O O X",
        " X O X",
        "  X X O"
    )

    $game = [Connect]::new($board)
    $game.GetWinner()
    Returns: [Winner]::X
#>
Enum Winner {
    X
    O
    NONE
}
class Coordenate {
    [int]$Y
    [int]$X

    Coordenate($Y,$X) {
        $this.Y = $Y
        $this.X = $X
    }

    [bool]
    Equals($other) {
        return $this.X -eq $other.X -and $this.Y -eq $other.Y
    }
}
class Tile {
    [Winner]$OccupiedBy
    [Coordenate]$Location
    [Tile[]]$LinkedWith

    Tile ([int]$Y,[int]$X,[Winner]$OccupiedBy) {
        $this.Location = [Coordenate]::new($Y,$X)
        $this.OccupiedBy = [Winner]$OccupiedBy
    }

    [void]
    Link($tile) {
        if ($tile -notin $this.LinkedWith) { # Precaution test from previous try (doesn't hurt much)
            $this.LinkedWith += $tile
        }
    }
    [bool]
    Equals($other) {
        return $this.OccupiedBy -eq $other.OccupiedBy -and $this.Location -eq $other.Location
    }
}
Class Connect {
    [Tile[]]$board
    [Coordenate]$maxCoord
    [Tile[]]$tiles_X
    [Tile[]]$tiles_O

    # Constructor
    Connect($_input) {
        # Base properties definition
        for ($y = 0; $y -lt $_input.Count; $y++) {
            [array]$row = $_input[$y].Trim(' ') -split ' '
            for ($x = 0; $x -lt $row.Count; $x++) {
                $occupant = $row[$x]
                if ($occupant -notin [Winner].GetEnumNames()) {$occupant = 'NONE'}
                $this.board += [Tile]::new($y,$x,$occupant)
            }
            $this.maxCoord = [Coordenate]::new($y, $x-1)
        }
        $this.tiles_X = $this.board | Where-Object OccupiedBy -EQ X
        $this.tiles_O = $this.board | Where-Object OccupiedBy -EQ O
        # Tile iteration and link registration
        for ($y = 0; $y -le $this.maxCoord.Y; $y++) {
            for ($x = 0; $x -le $this.maxCoord.X; $x++) {
                [array]$checks = @( # possible links
                    @{ Y = $y-1 ; X = $x   },
                    @{ Y = $y-1 ; X = $x+1 },
                    @{ Y = $y   ; X = $x-1 },
                    @{ Y = $y   ; X = $x+1 },
                    @{ Y = $y+1 ; X = $x-1 },
                    @{ Y = $y+1 ; X = $x   }
                ) | Where-Object {$_.Y -ge 0 -and $_.Y -le $this.maxCoord.Y -and $_.X -ge 0 -and $_.X -le $this.maxCoord.X}
                $this_Tile = $this.GetTile($y,$x)
                for ($i = 0; $i -lt $checks.Count; $i++) {
                    if ($this_Tile.OccupiedBy -ne [Winner]::NONE ) {
                        $other_Tile = $this.GetTile($checks[$i].Y,$checks[$i].X)
                        if ($this_Tile.OccupiedBy -eq $other_Tile.OccupiedBy) {
                            $this_Tile.Link($other_Tile)
                        }
                    }
                }
            }
        }
    }

    [Winner] 
    GetWinner() {
        # Paths registration from starter tiles
        $Starters = @{
            X = $this.tiles_X | Where-Object {$_.Location.X -eq 0}
            O = $this.tiles_O | Where-Object {$_.Location.Y -eq 0}
        }
        $Paths = @{
            X = @($Starters.X)
            O = @($Starters.O)
        }
        for ($i = 0; $i -lt $this.tiles_X.Count; $i++) {
            $Paths.X = $this.AddLinkedtoPath($Paths.X)
        }
        for ($i = 0; $i -lt $this.tiles_O.Count; $i++) {
            $Paths.O = $this.AddLinkedtoPath($Paths.O)
        }
        # Paths evaluation
        $winners = @{
            X = $this.maxCoord.X -in $Paths.X.Location.X
            O = $this.maxCoord.Y -in $Paths.O.Location.Y
        }
        # Output 
        if ($winners.X -and $winners.O) { throw "Something went wrong somehow" }
        elseif ($winners.X) { $winner = [Winner]::X }
        elseif ($winners.O) { $winner = [Winner]::O }
        else { $winner = [Winner]::NONE }

        return $winner
    }

    # >> Auxiliar functions

    [Tile] # Used in Constructor
    hidden GetTile($y,$x) {
        return $this.board | Where-Object {$_.Location.Y -eq $y -and $_.Location.X -eq $x}
    }

    [Tile[]] # Used in GetWinner()
    hidden AddLinkedtoPath([Tile[]]$PathArray) {
        foreach ($link in $PathArray.LinkedWith) {
            if ($link -notin $PathArray) {
                $PathArray += $link
            }
        }
        return $PathArray
    }
}