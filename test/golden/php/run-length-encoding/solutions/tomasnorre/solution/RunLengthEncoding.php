<?php

/**
 * This is one-to-one rip off/copy from https://exercism.org/tracks/php/exercises/run-length-encoding/solutions/zembrowski,
 * I found it so clever that I went for that solution too. One of the benefits or reading other solutions is
 * Learning!
 */

function encode(string $input): string
{
    return preg_replace_callback(
        '/(.)\1+/', // https://regexr.com/5o980
        static function ($match) {
            return strlen($match[0]) . $match[1];
        },
        $input
    );
}

function decode(string $input): string
{
    return preg_replace_callback(
        '/(\d+)(\D)/', // https://regexr.com/5o97t
        static function ($match) {
            return str_repeat($match[2], $match[1]);
        },
        $input
    );
}
