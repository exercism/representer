Function Get-Slices() {
    [CmdletBinding()]
    Param(
        [string]$Series,
        [int]$SliceLength
    )

    if ([string]::IsNullOrEmpty($Series)) {
        throw "Series cannot be empty."
    }

    if ($SliceLength -lt 0) {
        throw "Slice length cannot be negative."
    }

    if ($SliceLength -eq 0) {
        throw "Slice length cannot be zero."
    }

    if ($SliceLength -gt $Series.Length) {
        throw "Slice length cannot be greater than series length."
    }

    $result = @()

    for ($i = 0; $i -le $Series.Length - $SliceLength; $i++) {
        $result += $Series.Substring($i, $SliceLength)
    }

    return $result
}