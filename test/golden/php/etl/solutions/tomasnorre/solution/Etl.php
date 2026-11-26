<?php

declare(strict_types=1);

function transform(array $input): array
{
    $result = [];
    foreach ($input as $key => $values) {
        foreach ($values as $value) {
            $result[strtolower($value)] = $key;
        }
    }
    return $result;
}
