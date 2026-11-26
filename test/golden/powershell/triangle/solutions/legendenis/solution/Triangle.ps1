Function Check-Triangle() {
    Param(
        [double[]]$Sides
    )
    
    return (
        ($Sides[0] + $Sides[1] -ge $Sides[2]) -and
        ($Sides[0] + $Sides[2] -ge $Sides[1]) -and
        ($Sides[1] + $Sides[2] -ge $Sides[0])
    )
}
Enum Triangle {
    EQUILATERAL
    ISOSCELES
    SCALENE
}



Function Get-Triangle() {
    Param(
        [double[]]$Sides
    )
    
    $AllSidesPositive = ($Sides | Where-Object {$_ -le 0}).Count -eq 0
    if (!$AllSidesPositive) {
        throw "*All side lengths must be positive.*"
    }

    
    if (!(Check-Triangle -Sides $Sides)) {
        throw "*Side lengths violate triangle inequality.*"
    }


    $Count = 0 
    for ($i = 0; $i -lt 3; $i++){
        
        if ($Sides[$i] -eq $Sides[($i + 1) % 3]){
            $Count++ 
        }
    }

    
    switch ($Count) {
        0 {return [Triangle]::SCALENE }
        1 {return [Triangle]::ISOSCELES}
        {2 -or 3} {return [Triangle]::EQUILATERAL}
    }

    
}

