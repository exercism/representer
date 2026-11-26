<?php

class PizzaPi
{
    public function calculateDoughRequirement($pizzas, $persons)
    {
        return $pizzas * (($persons * 20) + 200);
    }

    public function calculateSauceRequirement($pizzas, $canVolume)
    {
        return $pizzas * 125 / $canVolume;
    }

    public function calculateCheeseCubeCoverage($side, $thick, $diameter)
    {
        return floor(($side ** 3) / ($thick * M_PI * $diameter));
    }

    public function calculateLeftOverSlices($pizzas, $friends)
    {
        return $pizzas * 8 % $friends;
    }
}
