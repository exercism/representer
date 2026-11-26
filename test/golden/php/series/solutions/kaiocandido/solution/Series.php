<?php

function slices(string $digits, int $series): array
{
    $arrayfinal = [];

    if ($series <= 0) {
    throw new Exception("Series length cannot be zero or negative");
    }
    
    if ($series > strlen($digits)) {
        throw new Exception("Series length cannot be longer than the string");
    }
    
    if ($digits === "") {
        throw new Exception("Cannot create slices from empty string");
    }

    for($i=0; $i<=strlen($digits) - $series; $i++){
        $arrayfinal[] = substr($digits, $i, $series);
    }

    return $arrayfinal;
}
