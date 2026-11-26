Function Test-MatchingBrackets() {
    <#
    .SYNOPSIS
    Determine if all brackets inside a string paired and nested correctly.
    
    .DESCRIPTION
    Given a string containing brackets `[]`, braces `{}`, parentheses `()`, or any combination thereof, verify that any and all pairs are matched and nested correctly.
    The string may also contain other characters, which for the purposes of this exercise should be ignored.
    
    .PARAMETER Text
    The string to be verified.
    
    .EXAMPLE
    Test-MatchingBrackets("[]") => True
    Test-MatchingBrackets("[)]") => False
    #>
    [CmdletBinding()]
    Param(
        [string]$Text
    )

    $bracketPairs = @{
        "[" = "]"
        "{" = "}"
        "(" = ")"
    }

    $Text = $Text -replace "[^\$(($bracketPairs.Keys - $bracketPairs.Values) -join "\")]", ""

    $stack = New-Object System.Collections.Stack

    foreach ($char in $Text.ToCharArray()) {
        if ($bracketPairs.ContainsKey($char.ToString())) {
            $stack.Push($char)
        } 
        elseif ($stack.Count -eq 0 -or $bracketPairs[$stack.Pop().ToString()] -ne $char.ToString()) {
            return $false
        }
    }

    return $stack.Count -eq 0
}