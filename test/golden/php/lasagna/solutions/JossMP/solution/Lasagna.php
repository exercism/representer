<?php

declare(strict_types=1);

class Lasagna
{
    private $expectedCookTime = 40;
    private $preparationTime = 2;

    // Please define the 'expectedCookTime()' function
    function expectedCookTime():int{
        return $this->expectedCookTime;
    }

    // Please define the 'remainingCookTime($elapsed_minutes)' function
    function remainingCookTime($elapsed_minutes):int{
        return $this->expectedCookTime-$elapsed_minutes;
    }

    // Please define the 'totalPreparationTime($layers_to_prep)' function
    function totalPreparationTime($layers_to_prep):int{
        return $this->preparationTime*$layers_to_prep;
    }
    // Please define the 'totalElapsedTime($layers_to_prep, $elapsed_minutes)' function
    function totalElapsedTime($layers_to_prep, $elapsed_minutes):int{
        return $this->totalPreparationTime($layers_to_prep) + $this->expectedCookTime() - $this->remainingCookTime($elapsed_minutes);
    }
    // Please define the 'alarm()' function
    function alarm():string{
        return "Ding!";
    }
}
