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

    if ($HeyBob.TrimEnd()[-1] -eq "?" -and $HeyBob -cmatch "^[^a-z]*$" -and $HeyBob -match "[A-Z]")
    {
        Return "Calm down, I know what I'm doing!"
    }
    elseif ([string]::IsNullOrWhiteSpace($HeyBob))
    {
        Return "Fine. Be that way!"
    }
    elseif ($HeyBob.TrimEnd()[-1] -eq "?")
    {
        Return "Sure."
    }
    elseif  ($HeyBob -cmatch "^[^a-z]*$" -and $HeyBob -match "[A-Z]")
    {
        Return "Whoa, chill out!"
    }
    else
    {
        Return "Whatever."
    }



    Throw "Please implement this function"
}
