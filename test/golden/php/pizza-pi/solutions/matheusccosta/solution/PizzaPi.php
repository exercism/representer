<?php

class PizzaPi
{
    public function calculateDoughRequirement(int $pizzas, $persons)
    {
        return $pizzas * (($persons * 20) + 200);
    }

    public function calculateSauceRequirement(int $pizzas, $sauceCan)
    {
        return $pizzas * (125/$sauceCan);
    }

    public function calculateCheeseCubeCoverage(int $dimension, float $thick, int $diameter)
    {
        $result =  ($dimension*$dimension*$dimension) / ($thick * 3.1415 * $diameter);
        return intval($result);
    }

    public function calculateLeftOverSlices(int $pizzas, $friends)
    {
        return ($pizzas*8)%$friends;
    }
}
