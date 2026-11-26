<#
.SYNOPSIS
Reverse a string

.DESCRIPTION
Reverses the string in its entirety. That is it does not reverse each word in a string individually.

.PARAMETER Forward
The string to be reversed

.EXAMPLE
Get-ReverseString "PowerShell"
#>Function Get-ReverseString {
    [CmdletBinding()]
    Param(
        [Parameter(Position=1, ValueFromPipeline=$true)]
        [string]$Forward
	)
    

    $len = $Forward.Length
    $reverse = ""

    for ($i = $len; $i -ge 0; $i--){
        $reverse += $Forward[$i]
    }
    $reverse

	# Throw "Function not implemented"
}