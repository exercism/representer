Function Invoke-Encode() {
    <#
    .SYNOPSIS
    Encode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to encode.

    .EXAMPLE
    Invoke-Encode -Phrase "yes"
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $Phrase,$abc,$cba = set-variables -Phrase $Phrase
    $output = ''
    foreach ($letter in $Phrase.ToLower().ToCharArray()) {
        if ($letter -match '[0-9]') {
            $output += $letter
        } else {
            $output += $cba[$abc.IndexOf($letter)]
        }
        
    }

    return (($output -split '(.{5})' -ne '') -join ' ')
}

Function Invoke-Decode(){
    <#
    .SYNOPSIS
    Decode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to decode.

    .EXAMPLE
    Invoke-Decode -Phrase "yes"
    #>
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )
    
    $Phrase,$abc,$cba = set-variables -Phrase $Phrase
    $output = ''
    foreach ($letter in $Phrase.ToLower().ToCharArray()) {
        if ($letter -match '[0-9]') {
            $output += $letter
        } else {
            $output += $abc[$cba.IndexOf($letter)]
        }
    }

    return $output
}
function set-variables ($Phrase) {
    $abc = $cba = @()
    98..122|ForEach-Object{ $abc += [char]$_ }
    122..97|ForEach-Object{ $cba += [char]$_ }
    return ($Phrase -replace "\W"),$abc,$cba
}




Invoke-Encode -Phrase "Testing,1 2 3, testing."