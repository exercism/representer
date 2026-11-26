<?php

class PizzaPi
{
    public function calculateDoughRequirement($number_of_pizzas, $number_of_people)
    {
        return $number_of_pizzas * ($number_of_people * 20 + 200);
    }

    public function calculateSauceRequirement($number_of_pizzas, $sauce_can_volume)
    {
        return ($number_of_pizzas * 125) / $sauce_can_volume;
    }

    public function calculateCheeseCubeCoverage($cheese_dimension, $cheese_thickness, $pizza_diamater)
    {
        return floor(($cheese_dimension ** 3) / ($cheese_thickness * pi() * $pizza_diamater));
    }

    public function calculateLeftOverSlices($number_of_pizzas, $number_of_friends)
    {
        return ($number_of_pizzas * 8) % $number_of_friends;
    }
}
