<?php
declare(strict_types=1);

function isIsogram(string $word): bool
{
    $data = mb_str_split(preg_replace('/[\s-]/', '', mb_strtolower($word)));
    return array_unique($data) === $data;
}