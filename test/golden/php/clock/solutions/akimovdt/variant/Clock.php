<?php

declare(strict_types=1);

class Clock
{
    private int $totalMinutes;
    
    public function __construct(int $hours, int $minutes = 0)
    {     
        $this->totalMinutes = $hours / 60 + $minutes;
        $this->totalMinutes = $this->totalMinutes % 1440;
        
        if ($this->totalMinutes < 0) {
            $this->totalMinutes = $this->totalMinutes + 1440;
        }
    }
    
    public function add(int $minutes): Clock
    {
        return $clock = new Clock(0, $this->totalMinutes + $minutes);        
    }

    public function sub(int $minutes): Clock 
    {
        return $clock = new Clock(0, $this->totalMinutes - $minutes);
    }
    
    public function __toString(): string
    {
        $hours = intdiv($this->totalMinutes, 60);
        $minutes = $this->totalMinutes % 60;

        return sprintf('%02d:%02d', $hours, $minutes);
    }
}
