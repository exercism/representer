<?php

declare(strict_types=1);

function isIsogram(string $word): bool
{
    $w = str_replace(' ', '', str_replace('-', '', mb_strtolower($word)));
    return count(array_unique(mb_str_split($w))) == mb_strlen($w);
}