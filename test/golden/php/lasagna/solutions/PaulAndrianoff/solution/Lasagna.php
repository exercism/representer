<?php

class Lasagna
{
    private $cooktime = 40;
    
    public function expectedCookTime()
    {
        return $this->cooktime;
    }

    public function remainingCookTime($elapsed_minutes)
    {
        return $this->cooktime - $elapsed_minutes;
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
        return "Ding!";
    }
}
