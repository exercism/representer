Function Invoke-Encode() {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [string]$Data
    )
    if ($Data -match '[0-9]') { throw "caca" }
    [string[]]$charArray = $Data.ToCharArray()
    $accumulation = @()
    for ($i = 0; $i -lt $charArray.Count; $i++) {
        if ($accumulation[-1].Char -ceq $charArray[$i]) {
            $accumulation[-1].Number += 1
        } else {
            $accumulation += [PSCustomObject]@{ Char = $charArray[$i] ; Number = 1 }
        }
    }
    $output = ''
    $accumulation | ForEach-Object {
        $char = $_.Char
        $number = $_.Number
        if ($number -eq 1) {
            $output += $char
        } else {
            $output += "$number$char"
        }
    }

    return $output

}
Function Invoke-Decode() {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [string]$Data
    )
    $number = $output = ''
    for ($i = 0; $i -lt $Data.Length; $i++) {
        $char = $Data.Substring($i,1)
        if ($char -match '[0-9]') {
            $number += $char
        } else {
            if ($number -eq '') {$number = 1}
            $output += $char * [int]$number
            $number = ''
        }
    }
    return $output
}