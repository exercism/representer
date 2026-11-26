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

const NUMBERS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

function encode(string $input): string
{
    if ($input === "") {
        return "";
    }

    $unencoded = format($input);
    $encoded = "";
    $currentVal = $unencoded[0];
    $valOccurrence = 1;

    for ($i = 1; $i < strlen($unencoded); $i++) {
        if ($unencoded[$i] != $currentVal) {
            $encoded .= ($valOccurrence === 1 ? "" : $valOccurrence) . $currentVal;
            $currentVal = $unencoded[$i];
            $valOccurrence = 1;
        } else {
            $valOccurrence += 1;
        }
    }

    $encoded .= ($valOccurrence === 1 ? "" : $valOccurrence) . $currentVal;

    return $encoded;
}

function format(string $input): string
{
    $formatted = str_replace(NUMBERS, "", $input);

    return $formatted;
}

function decode(string $input): string
{
    if ($input === "") {
        return "";
    }

    $decoded = "";
    $valOccurrence = "";

    for ($i = 0; $i < strlen($input); $i++) {
        if (!is_numeric($input[$i])) {
            $times = ($valOccurrence === "" ? 1 : intval($valOccurrence));
            $decoded .= str_repeat($input[$i], $times);
            $valOccurrence = "";
        } else {
            $valOccurrence .= $input[$i];
        }
    }

    return $decoded;
}
