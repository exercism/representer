<?php

declare(strict_types=1);

function steps(int $number): int
{
    if ($number <= 1) {
        throw new \InvalidArgumentException(
            'Only positive numbers are allowed'
        );
    }

    $step = 0;

    while (true) {
        if ($number === 1) {
            var_dump($step);
            return $step;
        }

        $step++;

        if ($number % 2) { // odd
            $number = $number * 3  + 1;
        } else { // even
            $number /= 2;
        }
    }
}
