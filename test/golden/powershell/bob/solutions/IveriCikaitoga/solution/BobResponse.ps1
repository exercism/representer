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
    if (-not (IsTalking($HeyBob))) {
        return "Fine. Be that way!"
    }
    if ((IsAQuestion($HeyBob)) -and (IsYelling($HeyBob))) {
        return "Calm down, I know what I'm doing!"
    }
    if (IsAQuestion($HeyBob)) {
        return "Sure."
    }
    if (IsYelling($HeyBob)) {
        return "Whoa, chill out!"
    }
    return "Whatever."
}
Function CleanText() {
    Param(
        [string]$Text
    )
    return $Text.Trim()
}
Function IsTalking() {
    Param(
        [string]$Text
    )
    return CleanText($Text) -ne ""
}
Function IsAQuestion() {
    Param(
        [string]$Text
    )
    $NewText = CleanText($Text)
    return $NewText.EndsWith("?")
}
Function IsYelling() {
    Param(
        [string]$Text
    )
    return ($Text -ceq $Text.ToUpper()) -and ($Text -cmatch "[A-Za-z]")
}
