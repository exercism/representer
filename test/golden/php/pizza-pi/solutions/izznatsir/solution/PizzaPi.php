<?php

class PizzaPi
{
    public function calculateDoughRequirement($pizzas, $persons)
    {
        return $pizzas * (($persons * 20) + 200);
    }

    public function calculateSauceRequirement($pizzas)
    {
        return ($pizzas * 125) / 250;
    }

    public function calculateCheeseCubeCoverage($cheese_dimension, $pizza_cheese_thickness, $pizza_diameter)
    {
        return floor($cheese_dimension**3 / ($pizza_cheese_thickness * M_PI * $pizza_diameter));
    }

    public function calculateLeftOverSlices($pizzas, $friends)
    {
        return ($pizzas * 8) % $friends;
    }
}
