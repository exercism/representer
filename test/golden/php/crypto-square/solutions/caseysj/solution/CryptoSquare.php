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

function crypto_square(string $plaintext): string
{
    $plaintext = strtolower(str_replace(" ", "", $plaintext));
    $plaintext = preg_replace('/[^a-z|0-9]/', "", $plaintext);
    $length = strlen($plaintext);
    $square = (int)round(sqrt($length));
    $chunks = (int)$square;

    while ($chunks * $square < $length) {
        $chunks++;
    }

    $codeArray = [];
    $whitespaceNeeded = ($square * $chunks) - $length;

    for ($a = 0; $a < $whitespaceNeeded; $a++) {
        $plaintext .= " ";
    }

    for ($i = 0; $i < $square; $i++) {
        $codeArray[$i] = substr($plaintext, 0, $chunks);
        $plaintext = substr($plaintext, $chunks);
    }

    $ans = "";

    for ($j = 0; $j < $chunks; $j++) {
        for ($k = 0; $k < count($codeArray); $k++) {
            $ans .= $codeArray[$k][0];
            $codeArray[$k] = substr($codeArray[$k], 1);
        }
    }

    $spaced = "";

    for ($b = 0; $b < $chunks; $b++) {
        $spaced .= substr($ans, 0, $square) . " ";
        $ans = substr($ans, $square);
    }

    return substr($spaced, 0, strlen($spaced) - 1);
}
