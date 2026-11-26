<?php

declare(strict_types=1);

function crypto_square(string $text): string
{
    return !$text ? $text : encode($text);
}

function encode(string $text): string
{
    $text = preg_replace('/[\W]/', '', strtolower($text));
    $len = strlen($text);
    $r = (int) round(sqrt($len));
    $c = $len <= $r ** 2 ? $r : $r + 1;
    $text = str_pad($text, $r * $c);
    $rows = array_fill(0, $c, '');
    for ($i = 0; $i < $r / $c; $i++) {
        $rows[$i % $c] .= $text[$i];
    }
    return implode(' ', $rows);
} 
