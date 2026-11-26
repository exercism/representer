<?php

declare(strict_types=1);

class Lasagna
{
    
    // Please define the 'expectedCookTime()' function
function expectedCookTime ()
    {
        return 40;
    }

    // Please define the 'remainingCookTime($elapsed_minutes)' function
function remainingCookTime ($minutesInOven)
{
    return  $this->expectedCookTime() - $minutesInOven;
}
    
    // Please define the 'totalPreparationTime($layers_to_prep)' function
function totalPreparationTime ($layers)
{    
    return $layers * 2;
}
    
    // Please define the 'totalElapsedTime($layers_to_prep, $elapsed_minutes)' function
function totalElapsedTime ($layers, $minutesInOven)
{
    return $this->totalPreparationTime($layers) + $minutesInOven;
}

    // Please define the 'alarm()' function
    function alarm () 
{
    $message = "Ding!";
    return $message;
}
}
