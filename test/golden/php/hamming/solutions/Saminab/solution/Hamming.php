<?php

declare(strict_types=1);

function distance(string $strandA, string $strandB): int
{
    $strandA_length = strlen($strandA);
    $strandB_length = strlen($strandB);
    $count = 0;
    $i = 0;

    if($strandA_length != $strandB_length) {
        throw new InvalidArgumentException('DNA strands must be of equal length.');
    }
    else {
        while($i<$strandA_length) {
            if($strandA[$i] != $strandB[$i]) {
                $count++;
            }
            $i++;
        }
    }
    
return $count;
}
