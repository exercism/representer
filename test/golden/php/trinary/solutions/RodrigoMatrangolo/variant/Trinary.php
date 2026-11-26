<?php


declare(strict_types=1);

function toDecimal(string $number): int
{
    $binarys = str_split($number);
    $result = 0;
    $i = count($binarys) + 1;

    foreach ($binarys as $n) {
        if ($n > 2) {
            return 0;
        }
        $result += $n * (3 ** $i);
        $i--;
    }

    return $result;
}