Function Test-Luhn() {
    [CmdletBinding()]
    Param(
        [string]$Value
    )
    $s = $Value.replace(" ","")
    if ($s -match "[^0123456789]") {
        return $false
    }
    if($s.Length -lt 2) {
        return $false
    }
    $t = $s.ToCharArray()
    [Array]::Reverse($t)
    $c = 0
    for($i = 0; $i -lt $t.Length ; $i++) {
        $x = [int]::Parse($t[$i])
        if($i % 2 -ne 0) {
            if($x -gt 4) {
                $c += $x * 2 - 9
            } else {
                $c += $x * 2
            }
        } else {
            $c += $x
        }
    }    
    return $c % 10 -eq 0
}
