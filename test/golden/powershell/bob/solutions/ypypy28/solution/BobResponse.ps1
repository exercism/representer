Function Get-BobResponse() {
    <#
    .SYNOPSIS
    Bob is a lackadaisical teenager. In conversation, his responses are very limited.
    
    .DESCRIPTION
    Bob is a lackadaisical teenager. In conversation, his responses are very limited.

    Bob answers 'Sure.' if you ask him a question.

    He answers 'Whoa, chill out!' if you yell at him.

    He answers 'Calm down, I know what I'm doing!' if you yell a question at him.

    He says 'Fine. Be that way!' if you address him without actually saying
    anything.

    He answers 'Whatever.' to anything else.
    
    .PARAMETER HeyBob
    The sentence you say to Bob.
    
    .EXAMPLE
    Get-BobResponse -HeyBob "Hi Bob"
    #>
    [CmdletBinding()]
    Param(
        [string]$HeyBob
    )


    $q = ($HeyBob -replace '\s+$','').EndsWith("?")
    # $yell = !(($HeyBob -cmatch "[a-z]") -Or ($heyBob -cmatch "\d+"))
    $heyYELL = $HeyBob.ToUpper()
    $yell = ($HeyBob -replace '\W|\d','' ) -ceq ($heyYELL -replace '\W|\d','' ) -And $heyYELL -cmatch '[A-Z]'
    # echo "q=$a yell=$yell"

    if ($q -And $yell) {
        return "Calm down, I know what I'm doing!"
    }

    if ($q) {
        return "Sure."
    }

    if ($yell) {
        return "Whoa, chill out!"
    }
    
    if ($HeyBob -cmatch "^\s*$") {
        return "Fine. Be that way!"
    }

    return "Whatever."
    
}
