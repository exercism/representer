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

function isValid(string $number): bool
{
    //sanitize the input: 
    $sanitized_number = str_replace(" ", "", $number);

    if (strlen($sanitized_number) <= 1 || preg_match('/\D/', $sanitized_number) ) {
        return false;
    }
    
    $sum = 0;
    $doubleNext = false;
    for ($i = strlen($sanitized_number) - 1; $i >= 0; $i--) {
        $num = (int) $sanitized_number[$i];
        if ($doubleNext) {
            $num *= 2;
            $num = $num > 9 ? $num - 9 : $num;
        }
        $sum += $num;
        $doubleNext = !$doubleNext;
    }
    return $sum % 10 === 0;  
}
