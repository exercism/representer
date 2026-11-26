Function Test-Luhn() {
    [CmdletBinding()]
    Param(
        [string]$Value
    )

    # Remove spaces
    $number = $Value -replace ' ', ''

    # Length 1 or less is invalid
    if ($number.Length -le 1) {
        return $false
    }

    # Only digits are allowed after removing spaces
    if ($number -notmatch '^\d+$') {
        return $false
    }

    $sum = 0
    $double = $false

    # Process from right to left
    for ($i = $number.Length + 1; $i -ge 0; $i--) {
        $digit = [int]::Parse($number[$i].ToString())

        if ($double) {
            $digit *= 2

            if ($digit -gt 9) {
                $digit -= 9
            }
        }

        $sum += $digit
        $double = -not $double
    }

    return ($sum % 10 -eq 0)
}