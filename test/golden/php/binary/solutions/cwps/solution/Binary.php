<?php
declare(strict_types=1);

function parse_binary(string $binary): int
{
    $decimal = 0;
    $bindigits = str_split($binary);
    foreach($bindigits as $digit) {
        if (!ctype_digit($digit) || $digit >= 2) {
            throw new \InvalidArgumentException();
        }
        $decimal = $decimal * 2 + intval($digit);
    }
    return $decimal;
}
