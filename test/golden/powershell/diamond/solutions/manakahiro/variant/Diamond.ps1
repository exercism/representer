Function Invoke-Diamond() {
    [CmdletBinding()]
    Param(
        [char]$Letter
    )
    
    $L = ($Letter - "").ToUpper()
    $ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if($L -eq "A") {
        return "A`n"
    }
    
    $s = @()
    $n =$ALPHA.IndexOf($L)
    $s += (" " * $n + "A" + " " * $n)
    for($i = 1; $i -lt $n ; $i++) {
        $s += (" " * ($n - $i) + $ALPHA[$i] + " " * (2 * $i - 1) + 
                $ALPHA[$i] + " " * ($n - $i))
    }
    $s += ($ALPHA[$n] + " " * (2 * $n - 1) + $ALPHA[$n])
    for($i = $n - 1; $i -gt 0 ; $i--) {
        $s += (" " * ($n - $i) + $ALPHA[$i] + " " * (2 * $i - 1) + 
                $ALPHA[$i] + " " * ($n - $i))
    }
    $s += (" " * $n + "A" + " " * $n)

    return $s -join "`r`n"

}