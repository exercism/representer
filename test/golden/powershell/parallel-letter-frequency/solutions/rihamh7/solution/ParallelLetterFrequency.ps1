Function Get-LetterFrequencies() {
    <#
    .SYNOPSIS
    Count the frequency of letters in texts using parallel computation.

    .PARAMETER Texts
    An array of strings.
    #>
    [CmdletBinding()]
    Param(
        [string[]]$Texts
    )
    
    # ----

    $letters = @{}

    foreach ($Text in $Texts) {
        foreach ($c in $Text.ToCharArray()) {
            if ([char]::IsLetter($c)) {
                $l = $c.ToString().ToLower()
                $letters[$l]++
            }
        }
    }

    $letters
}
