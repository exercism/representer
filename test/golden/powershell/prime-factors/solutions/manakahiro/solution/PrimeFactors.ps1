Function Invoke-PrimeFactors() {
     [CmdletBinding()]
    Param(
        [Int64]$Number
    )
    $Limit = [Math]::Floor([Math]::sqrt($Number))
    $sv = 0..$Limit
    $sv[1] = 0
    for($i = 2; $i -le $Limit ; $i++) {
        if($sv[$i] -ne 0){
            for($j = $i * 2; $j -le $Limit ; $j += $i) {
                $sv[$j] = 0
            }
        }
    }
    $p = ($sv | ? { $_ -ne 0 })
    $f = @()
    foreach( $n in $p) {
        while($Number % $n -eq 0) {
            $f += $n
            $Number /= $n
        }
    }
    if($Number -gt 1) {
        $f += $Number
    }
    return $f
}
