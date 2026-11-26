<?php

declare(strict_types=1);

function reverseString(string $text): string
{
    $arr = [];
    foreach (str_split($text) as $char) {
        array_unshift($arr, $char);
    }
    return join("", $arr);
}
