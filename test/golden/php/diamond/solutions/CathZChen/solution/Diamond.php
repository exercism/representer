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

function diamond(string $letter): array
{
    $asc = ord($letter);
    $results = [];

    $outer_spaces = $asc - 65;
    $inner_spaces = 0;
    for ($i = 65; $i <= $asc; $i++) 
    {
        $side = "";
        $middle = chr($i);
        while ($outer_spaces > 0) {
            $side .= " ";
            $outer_spaces--;
        }
        while ($inner_spaces > 0) {
            $middle .= " ";
            $inner_spaces--;
        }

        $outer_spaces = $asc - $i - 1;
        $inner_spaces = 2 * ($i + 1 - 65) - 1;
        if ($inner_spaces > 1)
            $middle .= chr($i);
        
        array_push($results, $side.$middle.$side);
    }

    for ($i = count($results) - 2; $i >= 0; $i--)
        array_push($results, $results[$i]);

    return $results;
}
