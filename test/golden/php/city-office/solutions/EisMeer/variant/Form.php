<?php

class Form
{
    public static function blanks(int $length): string
    {
        return str_repeat(' ', $length);
    }

    public static function letters(string $word): array
    {
        return str_split($word);
    }

    public static function checkLength(string $word, int $max_length): bool
    {
        return strlen($word) < $max_length;
    }

    public static function formatAddress(Address $address): string
    {
        return $address->street . "\n"
            . $address->postal_code . ' '
            . $address->city;
    }
}