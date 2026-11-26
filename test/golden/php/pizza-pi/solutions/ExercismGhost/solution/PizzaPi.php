<?php

class PizzaPi
{
    public function calculateDoughRequirement($number_of_pizzas, $number_of_served)
    {
        return $number_of_pizzas * (($number_of_served * 20) + 200);
    }

    public function calculateSauceRequirement($number_of_pizzas, $sauce_can_volume)
    {
        return $number_of_pizzas * 125 / $sauce_can_volume;
    }

    public function calculateCheeseCubeCoverage($side_length, $thickness, $diameter) 
    {
        return floor(($side_length**3) / ($thickness * pi() * $diameter));
    }

    public function calculateLeftOverSlices($number_of_pizzas, $number_of_friends)
    {
        return ($number_of_pizzas * 8) % $number_of_friends;
    }
}
