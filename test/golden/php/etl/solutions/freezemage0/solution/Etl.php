<?php


declare(strict_types=1);

function transform(array $input): array
{
    $map = [];
    foreach ($input as $score => $letters) {
        foreach ($letters as $letter) {
            $map[strtolower($letter)] = $score;
        }
    }

    return $map;
}
