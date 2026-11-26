<?php

class PizzaPi
{
    private const MINIMUM_DOUGH_GRAMS = 200;
    private const SLICES_PER_PIZZA = 8;
    private const PERSONS_PER_PIZZA = 20;
    private const SAUCE_PER_PIZZA = 125;

    public function calculateDoughRequirement($pizzas, $persons): int
    {
        return $pizzas * (($persons * self::PERSONS_PER_PIZZA) + self::MINIMUM_DOUGH_GRAMS);
    }

    public function calculateSauceRequirement($pizzas, $sauceCanVolume): int
    {
        return ceil($pizzas * self::SAUCE_PER_PIZZA / $sauceCanVolume);
    }

    public function calculateCheeseCubeCoverage($dimension, $thickness, $diameter): int
    {
        $volume = $dimension ** 3;
        $coverage = $volume / ($thickness * PI() * $diameter);
        return floor($coverage);
    }

    public function calculateLeftOverSlices($pizzas, $friends): int
    {
        $totalSlices = $pizzas * self::SLICES_PER_PIZZA;
        $slicesPerFriend = intdiv($totalSlices, $friends);
        return $totalSlices - ($slicesPerFriend * $friends);
    }
}

