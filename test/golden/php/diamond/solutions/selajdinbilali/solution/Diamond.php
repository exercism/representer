<?php

declare(strict_types=1);

function spaces(int $numberOfSpaces)
{
    $spaces = '';

    for ($i = 0; $i < $numberOfSpaces; $i++) {
        $spaces .= ' ';
    }
    return $spaces;
}

function isOdd(int $number)
{
    if ($number % 2 == 0) {
        return false;
    } else {
        return true;
    }
}

function diamond(string $letter): array
{
    // return early
    if ($letter === 'A') {
        return ['A'];
    }

    // convert letter to number and remove - 64 to get the real index
    $indexOfLetter = ord($letter) - 64;

    // prepare diamond
    $diamond = [];

    // middleSpaces are odd and minimum 1
    $middleSpaces = 1;
    for ($i = 1; $i <= $indexOfLetter; $i++) {
        if ($i == 1) {
            $diamond[] = spaces($indexOfLetter - $i)
                . chr($i + 64)
                . spaces($indexOfLetter - $i);

            continue;
        }

        $diamond[] = spaces($indexOfLetter - $i)
            . chr($i + 64)
            . spaces($middleSpaces)
            . chr($i + 64)
            . spaces($indexOfLetter - $i);

        $middleSpaces = $middleSpaces + 2;
    }

    // the second half of the diamond is the first half inverted
    for ($j = $indexOfLetter - 1; $j > 0; $j--) {
        $diamond[] = $diamond[$j - 1];
    }

    return $diamond;
}
