<?php

declare(strict_types=1);

const ROMAN_MAP = [
    1000 => 'M',
    900 => 'CM',
    500 => 'D',
    400 => 'CD',
    100 => 'C',
    90 => 'XC',
    50 => 'L',
    40 => 'XL',
    10 => 'X',
    9 => 'IX',
    5 => 'V',
    4 => 'IV',
    1 => 'I',
];

function toRoman(int $number): string {
    $translation = '';
    foreach (ROMAN_MAP as $k => $v) {
        while ($number >= $k) {
            $number -= $k;
            $translation .= $v;
        }
    }
    return $translation;
}
