<?php

class PizzaPi
{
    public function calculateDoughRequirement($amountOfPizzas, $amountOfPeople)
    {
        return $amountOfPizzas * (($amountOfPeople * 20) + 200);
    }

    public function calculateSauceRequirement($amountOfPizzas, $volumePerCan)
    {
        return $amountOfPizzas * 125 / $volumePerCan;
    }

    public function calculateCheeseCubeCoverage($cheeseCubeLength, $cheeseThickness, $pizzaDiameter)
    {
        return floor(($cheeseCubeLength ** 3) / ($cheeseThickness * M_PI * $pizzaDiameter));
    }

    public function calculateLeftOverSlices($amountOfPizzas, $amountOfFriends)
    {
        return ($amountOfPizzas * 8) % $amountOfFriends;
    }
}
