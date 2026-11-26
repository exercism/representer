<?php

class Lasagna
{
    
    public function expectedCookTime()
    {
        return 40; 
    }

    public function remainingCookTime($elapsed_minutes)
    {
        $timer = $this->expectedCookTime(); 
        return $timer - $elapsed_minutes;
    }

    public function totalPreparationTime($layers_to_prep)
    {
        return $layers_to_prep * 2; 
    }

    public function totalElapsedTime($layers_to_prep, $elapsed_minutes)
    {
        return $this->totalPreparationTime($layers_to_prep) + $elapsed_minutes; 
    }

    public function alarm()
    {
        if ($this->remainingCookTime(40) != 0) {
            return "Ding!";
        }
    }
}
