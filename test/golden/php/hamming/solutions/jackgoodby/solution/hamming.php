<?php

function distance(string $strandA, string $strandB) : int
{
    if (strlen($strandA) != strlen($strandB)) {
        throw new InvalidArgumentException('DNA strands must be of equal length.');
    }

    $strandAArray = str_split($strandA);
    $strandBArray = str_split($strandB);
    $diffs = 0;

    foreach($strandAArray as $k => $strandAChar){
        if ($strandAChar != $strandBArray[$k]) {
            $diffs++;
        }
    }

    return $diffs;
}
