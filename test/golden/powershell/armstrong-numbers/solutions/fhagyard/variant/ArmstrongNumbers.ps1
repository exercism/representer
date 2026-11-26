Function Invoke-ArmstrongNumbers() {
    Param([Int64]$Number)
    $Str = $Number.ToString()
    Return (1..($Str.Length-1) | ForEach-Object {[Math]::Pow($Str[$_].ToString(),$Str.Length)} | Measure-Object -Sum).Sum -eq $Number
}