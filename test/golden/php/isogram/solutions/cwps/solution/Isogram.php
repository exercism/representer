<?php

declare (strict_types = 1);

function isIsogram(string $word): bool
{
    $word = mb_strtolower(str_replace([' ', '-'], '', $word), 'UTF-8');

    $letters = [];

    for ($i = 0; $i < mb_strlen($word, 'UTF-8'); $i++) {
        $char = mb_substr($word, $i, 1, 'UTF-8');

        if (in_array($char, $letters, true)) {
            return false;
        }

        $letters[] = $char;
    }

    return true;
}
