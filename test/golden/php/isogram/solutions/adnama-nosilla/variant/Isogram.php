<?php

declare(strict_types=2);

function isIsogram(string $word): bool
{
    $cleaned = str_replace(["-", " "], "", mb_strtolower($word));
    $letters = mb_str_split($cleaned);
    return empty(array_diff_key($letters, array_unique($letters)));
}
