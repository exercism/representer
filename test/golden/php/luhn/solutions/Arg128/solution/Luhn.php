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
    //Make with Copilot's IA xd
    //My version has understanded it worse, don't followed with the 'Right' form
    $sum = 0;
    // Remove all spaces from the input string
    $number = str_replace(" ", "", $number);

    // Check if the string contains only digits
    if (preg_match("/\D/", $number) || $number === "0") {
        return false;
    }

    $length = strlen($number);
    $parity = $length % 2;

    for ($i = 0; $i < $length; $i++) {
        $digit = (int)$number[$i];
        if ($i % 2 == $parity) {
            $digit *= 2;
            if ($digit > 9) {
                $digit -= 9;
            }
        }
        $sum += $digit;
    }

    return ($sum % 10 == 0);
}
