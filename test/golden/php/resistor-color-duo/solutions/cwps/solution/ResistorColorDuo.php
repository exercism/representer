<?php
declare(strict_types=1);


class ResistorColorDuo
{
    const COLOR_CODES = [
        "black",
        "brown",
        "red",
        "orange",
        "yellow",
        "green",
        "blue",
        "violet",
        "grey",
        "white"
    ];

    /**
     * Calculate the resistance value for a two-band resistor.
     *
     * @param array $colors An array containing two color band names.
     *
     * @return int The calculated resistance value in ohms.
     */
    public function getColorsValue(array $colors): int
    {
        return intval(
            array_search($colors[0], self::COLOR_CODES) .
            array_search($colors[1], self::COLOR_CODES)
        );
    }
}
