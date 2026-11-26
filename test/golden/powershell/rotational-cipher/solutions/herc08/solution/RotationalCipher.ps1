Function Invoke-RotationalCipher() {
    <#
    .SYNOPSIS
    Rotate a string by a given number of places.

    .DESCRIPTION
    Create an implementation of the rotational cipher, also sometimes called the Caesar cipher.
    
    .PARAMETER Text
    The text to rotate    

    .PARAMETER Shift
    The number of places to shift the text

    .EXAMPLE
    Invoke-RotationalCipher -Text "A" -Shift 1
    #>
    [CmdletBinding()]
    Param(
        [string]$Text, 
        [int]$Shift
    )
    
 $result = -join ($Text.ToCharArray() | ForEach-Object {
        if ($_ -ge 'a' -and $_ -le 'z') {
            # lowercase letter
            $charCode = ([int][char]$_ - [int][char]'a' + $Shift) % 26 + [int][char]'a'
        } elseif ($_ -ge 'A' -and $_ -le 'Z') {
            # uppercase letter
            $charCode = ([int][char]$_ - [int][char]'A' + $Shift) % 26 + [int][char]'A'
        } else {
            # non-alphabetic character remains unchanged
            $charCode = [int][char]$_
        }

        [char]$charCode
    })

    return $result
}