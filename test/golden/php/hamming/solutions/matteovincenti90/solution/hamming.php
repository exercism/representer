<?php

function distance(string $strandA, string $strandB) : int
{
    if (strlen($strandA) !== strlen($strandB)) {
        throw new InvalidArgumentException('DNA strands must be of equal length.');
    }

    $distance = 0;

    if ($strandA === $strandB) {
        return $distance;
    }

    $strandA = str_split($strandA);
    $strandB = str_split($strandB);

    for ($i = 0; $i < count($strandA); $i++) { 
        if ($strandA[$i] !== $strandB[$i]) {
            $distance++;
        }
    }

    return $distance;
}
