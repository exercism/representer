<?php

declare(strict_types=1);

class ResistorColorDuo
{
    private const COLORS = [
        "black" => 0,
        "brown" => 1,
        "red" => 2,
        "orange" => 3,
        "yellow" => 4,
        "green" => 5,
        "blue" => 6,
        "violet" => 7,
        "grey" => 8,
        "white" => 9
    ];

    private function getColorResistance(string $color): int
    {
        return self::COLORS[$color];
    }
    public function getColorsValue(array $colors): int
    {
        return (self::getColorResistance($colors[0]) * 10) + self::getColorResistance($colors[1]);
    }
}
