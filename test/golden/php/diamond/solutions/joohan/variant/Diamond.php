<?php

declare(strict_types=1);

/** @return string[] */
function diamond(string $letter): array
{
    $number = ord($letter) - ord('A') + 1;
    $out = array_fill(0, $number, str_repeat(' ', 2 * $number - 1));
    $dim = $number + 1;

    foreach ($out as $i => $row) {
        $char = chr($i + ord('A'));
        $out[$i][$dim - $i] = $char;
        $out[$i][$i - $dim - 1] = $char;
    }

    return [...$out, ...array_reverse(array_slice($out, 0, $dim))];
}
