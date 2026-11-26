<?php

declare(strict_types=1);

class Lasagna
{
    // Please define the 'expectedCookTime()' function
    public function expectedCookTime():int{
        return 40;
    }

    // Please define the 'remainingCookTime($elapsed_minutes)' function
    public function remainingCookTime(int $actualMinutes):int{
        return $this->expectedCookTime() - $actualMinutes;
    }
    
    // Please define the 'totalPreparationTime($layers_to_prep)' function
    public function totalPreparationTime(int $numberLayers):int{
        return ($numberLayers * 2);   
    }
    
    // Please define the 'totalElapsedTime($layers_to_prep, $elapsed_minutes)' function
    public function totalElapsedTime(int $numberLayers, $numberMiutesInOwven):int{
        return $this->totalPreparationTime($numberLayers) + $numberMiutesInOwven;
    }
    // Please define the 'alarm()' function
    public function alarm():string{
        return "Ding!";
    }
}
