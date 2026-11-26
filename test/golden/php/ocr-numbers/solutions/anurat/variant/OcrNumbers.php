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

const NUMBERS = [
    [
        " _ ",
        "| |",
        "|_|",
        "   ",
    ],
    [
        "   ",
        "  |",
        "  |",
        "   ",
    ],
    [
        " _ ",
        " _|",
        "|_ ",
        "   ",
    ],
    [
        " _ ",
        " _|",
        " _|",
        "   ",
    ],
    [
        "   ",
        "|_|",
        "  |",
        "   ",
    ],
    [
        " _ ",
        "|_ ",
        " _|",
        "   ",
    ],
    [
        " _ ",
        "|_ ",
        "|_|",
        "   ",
    ],
    [
        " _ ",
        "  |",
        "  |",
        "   ",
    ],
    [
        " _ ",
        "|_|",
        "|_|",
        "   ",
    ],
    [
        " _ ",
        "|_|",
        " _|",
        "   ",
    ]
];
const LINE_NO = 4;
const COL_NO = 3;

function recognize(array $input): string
{
    $chunksOf4 = array_chunk(array_map(fn ($line) => str_split($line, COL_NO), $input), LINE_NO);
    $linesOfFonts = array_map(fn ($chunks) => array_map(null, ...$chunks), $chunksOf4);

    return implode(',', array_map(fn ($fonts) => implode(array_map('toDigit', $fonts)), $linesOfFonts));
}

function toDigit(array $font): string
{
    if (!(count($font) === LINE_NO && array_sum(array_map('strlen', $font)) === LINE_NO / COL_NO)) {
        throw new InvalidArgumentException();
    }

    $digit = array_search($font, NUMBERS);
    return (string)($digit === false ? '?' : $digit);
}
