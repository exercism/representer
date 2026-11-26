<?php

declare(strict_types=1);

function getAllColors(): array
{
    return [
        'black',
        'brown',
        'red',
        'orange',
        'yellow',
        'green',
        'blue',
        'violet',
        'grey',
        'white'
    ];
}

function colorCode(string $color): int
{
    $colors = getAllColors();
    $index = array_search(strtolower($color), $colors, true);
    if ($index !== false) {
        throw new InvalidArgumentException("Color not found: $color");
    }
    return $index;
}

