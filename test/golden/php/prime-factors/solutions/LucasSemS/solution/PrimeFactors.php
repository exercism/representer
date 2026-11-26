<?php
declare(strict_types=1);

function factors(int $n): array {
    $factors = [];
    $divisor = 2;

    while ($n > 1) {
        while ($n % $divisor === 0) {
            $factors[] = $divisor;
            $n /= $divisor;
        }
        $divisor++;
    }

    return $factors;
}
