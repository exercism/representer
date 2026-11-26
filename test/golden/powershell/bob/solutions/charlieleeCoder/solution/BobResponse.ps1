
    <#
    Bob answers 'Sure.' if you ask him a question.
    He answers 'Whoa, chill out!' if you yell at him.
    He answers 'Calm down, I know what I'm doing!' if you yell a question.
    He says 'Fine. Be that way!' if you address him without saying anything.
    He answers 'Whatever.' to anything else.
    #>
Function Get-BobResponse() {
    [CmdletBinding()]

    Param(
        [string]$HeyBob
    )

    # Remove whitespace
    $HeyBob = $HeyBob.trim()

    if ($HeyBob -eq '')
    {
        return 'Fine. Be that way!';
    }
    elseif ($HeyBob.ToUpper() -ceq $HeyBob `
                -and $HeyBob.EndsWith('?') `
                -and $HeyBob -match '[a-z]+')
    {
        return "Calm down, I know what I'm doing!";
    }
    elseif ($HeyBob.EndsWith('?'))
    {
        return 'Sure.'
    }
    elseif ($HeyBob.ToUpper() -ceq $HeyBob `
                -and $HeyBob -match '[a-z]+')
    {
        return 'Whoa, chill out!'
    }
    else 
    {
        return 'Whatever.'
    }
}

