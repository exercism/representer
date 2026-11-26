<?php

function smallest(int $min, int $max): array
{
    return product($min, $max);
}

function largest(int $min, int $max): array
{
    return product($min, $max, true);
}

function product(int $min, int $max, bool $largest = false): array
{
    if ($min > $max) {
        throw new Exception();
    }

    $number = number(
        ($largest)
        ? range($max, $min)
        : range($min, $max)
    );

    if (! $number) {
        throw new Exception();
    }

    $factors = factors($number, $min, $max);

    return [$number, $factors];
}

function number(array $range): ?int
{
    $array = [];

    foreach ($range as $x) {
        foreach (range($x, array_reverse($range)[0]) as $y) {
            $product = $x * $y;
            if ((string) $product === strrev($product)) {
                $array[] = $product;
                if (count($array) > 2) {
                    ($range[0] > $range[1]) ? rsort($array) : sort($array);
                    return array_shift($array);
                }
            }
        }
    }

    return null;
}

function factors(int $number, int $min, int $max): array
{
    $result = [];

    for ($x = $min; $x <= sqrt($number); $x++) {
        if ($number % $x === 0) {
            $y = $number / $x;
            if ($y > $max) {
                continue;
            }
            $result[] = [$x, $y];
        }
    }

    return $result;
}
