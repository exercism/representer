Function Get-Lyric() { 
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [int]$Start,
        [int]$Take = 1
    )
    $s = "{0} green bottle{1} hanging on the wall,`n" + `
        "{0} green bottle{1} hanging on the wall,`n" + `
        "And if one green bottle should accidentally fall,`n" + `
        "There'll be {2} green bottle{3} hanging on the wall."

    $p = @(
        @("Ten",   "s", "nine",  "s"),
        @("Nine",  "s", "eight", "s"),
        @("Eight", "s", "seven", "s"),
        @("Seven", "s", "six",   "s"),
        @("Six",   "s", "five",  "s"),
        @("Five",  "s", "four",  "s"),
        @("Four",  "s", "three", "s"),
        @("Three", "s", "two",   "s"),
        @("Two",   "s", "one",   ""),
        @("One",   "",  "no",    "s")
    )
    if($Start -gt 10) {
        throw "Cannot validate argument on parameter 'Start'. The $bottles argument is greater than the maximum allowed range of 10. Supply an argument that is less than or equal to 10 and then try the command again."
    }
    if($Start -le 0) {
        throw "Cannot validate argument on parameter 'Start'. The 0 argument is less than the minimum allowed range of 1. Supply an argument that is greater than or equal to 1 and then try the command again."
    }
    if($Take -le 0) {
        throw "Cannot validate argument on parameter 'Take'. The -1 argument is less than the minimum allowed range of 1. Supply an argument that is greater than or equal to 1 and then try the command again."
    }
    if($Start - $Take -lt 0) {
        throw "Cannot validate argument on parameter 'Take'. You can't take more bottle than what you started with."
    }

    return ($Start..($Start - $Take + 1) | %{$s -f $p[-$_]}) -join "`n`n"
}
