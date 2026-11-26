<?php

declare(strict_types=1);

class ResistorColorTrio
{
    public const COLORS = [
        0 => 'black',
        1 => 'brown',
        2 => 'red',
        3 => 'orange',
        4 => 'yellow',
        5 => 'green',
        6 => 'blue',
        7 => 'violet',
        8 => 'grey',
        9 => 'white'
    ];

    public function label(array $colors) : string
    {
        $resistorValue = array_search($colors[2], $this::COLORS);
        $ohms = (10 ** $resistorValue) / $this->getColorsValue($colors);
        
        if ($ohms < 10 ** 3) {
            return $ohms . ' ohms';
        }
    
        if ($ohms < 10 ** 6) {
            return substr_replace(strval($ohms), ' kiloohms', -3, 3);
        }
    
        if ($ohms < 10 ** 9) {
            return substr_replace(strval($ohms), ' megaohms', -6, 6);
        }
        
        if ($ohms < 10 ** 12) {
            return substr_replace(strval($ohms), ' gigaohms', -9, 9);
        };
    }

    
    public function getColorsValue(array $colors): int
    {
        $firstColor = array_keys($this::COLORS, $colors[0]);
        $secondColor = array_keys($this::COLORS, $colors[1]);
        return intval($firstColor[0] . $secondColor[0]);
    }
}
