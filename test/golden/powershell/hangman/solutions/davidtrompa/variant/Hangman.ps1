<#
.SYNOPSIS
    Stimulate a game of hangman.
.DESCRIPTION
    Implement the logic and functionalities of a hangman game.
    The game started with 9 remaining guesses.
    Each incorrect guess will decrease the remaining guesses by 1.
    The game has 3 states: WIN, LOSE and ONGOING.
    You win when you correctly guess the word.
    You lose when you spent all of your guesses.
.EXAMPLE
    $game = [Hangman]::new("welcome")

    $game.RemainingGuesses
    Returns: 9
    $game.Display()
    Returns: "_______"

    $game.Guess("e")
    $game.Display()
    Returns: "_e____e"

    $game.Guess("z")
    $game.RemainingGuesses
    Returns: 8
#>


Enum Status {
    WIN
    LOSE
    ONGOING
}

Class Hangman {
    ### PROPERTIES ###
    [int]$RemainingGuesses
    [Status]$Status
    [array]$CharsUsed
    hidden [array]$Word
    hidden [array]$Chars

    ### CONSTRUCTOR ###
    Hangman ([string]$word) {
        $this.Word = $this.Chars = $this.CharsUsed = @()
        for ($i = 0; $i -lt $word.Length; $i++) {
            $this.Chars += '_'
            $this.Word += $word.Substring($i,1)
        }
        $this.Status = [Status]::ONGOING
        $this.RemainingGuesses = 10
    }

    ### METHODS ###
    [void]
    Guess($char) { # Object edition
        if ($this.Status -ne [status]::ONGOING) {
            throw 'The game has already ended.'
        }
        if ($char -notin $this.CharsUsed -and $char -in $this.Word) {
            for ($i = 0; $i -lt $this.Word.Count; $i++) {
                if ($this.Word[$i] -eq $char) {
                    $this.Chars[$i] = $this.Word[$i]
                }
            }
            $this.CharsUsed += $char
            if (-join($this.Chars) -eq -join($this.Word)) {
                $this.Status = [Status]::WIN
            }
        }
        else { $this.RemainingGuesses-- }
        if ($this.RemainingGuesses -lt 0) {
            $this.Status = [Status]::LOSE
        }
    }

    [string]
    Display() { # Output discovered letters
        return -join($this.Chars)
    }

    [Status]
    GetStatus() { # Output status
        return $this.Status
    }
}
