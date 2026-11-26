<?php

function slices(string $digits, int $size): array
{
    $length = strlen($digits);
    if ($size < 1 || $size > $length) {
        throw new Exception('Wrong size.');
    }
    $series = [];
    for ($i = 0; $i <= $length - $size; $i++) {
        $series[] = substr($digits, $i, $size);
    }
    return $series;
}
