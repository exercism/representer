Function Get-ReverseString {
    [CmdletBinding()]
    Param(
        [Parameter(Position=2, ValueFromPipeline=$true)]
        [string]$Forward
	)
	$r = [char[]]$Forward;
    [Array]::Reverse($r)
    $r -join ""
}
