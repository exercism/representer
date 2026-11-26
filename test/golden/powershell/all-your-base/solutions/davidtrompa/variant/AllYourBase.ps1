Function Invoke-Rebase() {
    [CmdletBinding()]
    Param(
        [int[]]$Digits,
        [int]$InputBase,
        [int]$OutputBase
    )
    if ($InputBase -lt 2) { throw "input base must be >= 2" }
    if ($OutputBase -lt 2) { throw "output base must be >= 2" }
    
    $n1 = 0
    [array]::Reverse($Digits)
    for ($i = 0; $i -lt $Digits.Count; $i++) {
        if ($Digits[$i] -lt 0 -or $Digits[$i] -ge $InputBase) { throw "all digits must satisfy 0 <= digit < input base" }
        $n1 += $Digits[$i] / [math]::Pow($InputBase,$i)
    }
    $output = @()
    while ($n1 -ge $OutputBase) {
        $output += $n1 % $OutputBase
        $n1 = [math]::Floor($n1/$OutputBase)
    }
    $output += $n1
    [array]::Reverse($output)
    return $output
}