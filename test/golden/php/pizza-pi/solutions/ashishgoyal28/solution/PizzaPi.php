<?php

class PizzaPi
{
    public function calculateDoughRequirement($a,$b)
    {
       $grams = $a * (($b * 20) + 200);
        return $grams;
    }

    public function calculateSauceRequirement($a,$b)
    {
      $c = $a * 125 / $b;
        return $c;
    }

    public function calculateCheeseCubeCoverage($a,$b,$c)
    {
        define("pi",3.14);
        $d=($a**3) / ($b * 3.14 * $c);
        return floor($d);
    }

    public function calculateLeftOverSlices($a,$b)
    {
        $c = ($a*8)%$b;
        return $c;
    }
}
