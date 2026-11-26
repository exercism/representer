Function Get-ColorCodeValue() {
    [CmdletBinding()]
    param (
        [string[]] $Colors
    )

    $color_list = @("black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white")
    
    ForEach ($item in $Colors) {
        if ($value_list.Length -ge 3) {
            break
        }
        $index = $color_list.IndexOf($item.ToLower())
        $value_list += $index.ToString()
    }
    return $value_list
}