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

function sieve(int $number): array
{
    if ($number == 1) {
        return [];
    }
    $composite_numbers = [];
    for ($i = 2; $i < $number; ++$i) {
        $max = $number / $i;
        for ($j = $i; $j <= $max; ++$j) {
            $current_number = $i * $j;
            if (!in_array($current_number, $composite_numbers)) {
                $composite_numbers[] = $current_number;
            }
        }
    }
    // return all that are not in the list and thus prime
    return array_values(array_diff(range(2, $number), $composite_numbers));
}
