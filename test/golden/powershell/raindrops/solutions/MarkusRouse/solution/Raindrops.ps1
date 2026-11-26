Function Get-Raindrops([int] $Rain) 
{
    $rainDropMap = @{
    3 = "Pling"
    5 = "Plang"
    7 = "Plong"
}

    $rainDrop = "";
    foreach ($divisor in $rainDropMap.Keys | Sort-Object)
    {
        if($Rain % $divisor -eq 0)
        {
            $rainDrop += $rainDropMap[$divisor]
        }
    }
    if(-not $rainDrop)
    {
        return $Rain
    }
    return $rainDrop;
}