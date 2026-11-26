<?php

declare(strict_types=1);

function isValid($digits): bool
{
    $normalized   = str_replace(' ', '', $digits);
    $digitsLength = strlen($normalized);
    if ($digitsLength <= 1) {
        return false;
    }

    if (preg_match('/\D/', $normalized)) {
        return false;
    }

    $double = false;

    return array_reduce(
        str_split(strrev($normalized)),
        static function ($sum, $digit) use (&$double) {
            if ($double) {
                $digit *= 2;
            }
            if ($digit > 9) {
                $digit -= 9;
            }
            $double = !$double;
            return $sum+$digit;
        },
        0
    ) % 10 === 0;
}
