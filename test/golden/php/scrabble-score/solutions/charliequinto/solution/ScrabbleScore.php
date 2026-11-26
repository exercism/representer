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

function score(string $word): int
{
    $letterValues = [
        'A' => 1, 'B' => 3, 'C' => 3, 'D' => 2, 'E' => 1,
        'F' => 4, 'G' => 2, 'H' => 4, 'I' => 1, 'J' => 8,
        'K' => 5, 'L' => 1, 'M' => 3, 'N' => 1, 'O' => 1,
        'P' => 3, 'Q' => 10, 'R' => 1, 'S' => 1, 'T' => 1,
        'U' => 1, 'V' => 4, 'W' => 4, 'X' => 8, 'Y' => 4,
        'Z' => 10
    ];

    $score = 0;
    $word = strtoupper($word);

    for ($i = 0; $i < strlen($word); $i++) {
        $letter = $word[$i];
        if (isset($letterValues[$letter])) {
            $score += $letterValues[$letter];
        }
    }

    return $score;
}