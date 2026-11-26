<?php

declare(strict_types=1);

class ResistorColorDuo
{
    
    public function getColorsValue(array $colors): int
    {
        $colorCode = ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"];
        
        return array_search($colors[0],$colorCode)*10+array_search($colors[1],$colorCode);
    }
}