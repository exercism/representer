<?php

class PizzaPi
{
    public function calculateDoughRequirement($x, $y)
    {
        return $x * (($y * 20) + 200);
        throw new \BadFunctionCallException("Implement the function");
    }

    public function calculateSauceRequirement($x, $y)
    {
        return $x * 125 / $y;
        throw new \BadFunctionCallException("Implement the function");
    }

    public function calculateCheeseCubeCoverage($x, $y, $z)
    {
        return floor(($x**3) / ($y * 3.14 * $z));
        throw new \BadFunctionCallException("Implement the function");
    }

    public function calculateLeftOverSlices($x,$y)
    {
        return ($x * 8) % $y;
        throw new \BadFunctionCallException("Implement the function");
    }
}
