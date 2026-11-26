<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

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