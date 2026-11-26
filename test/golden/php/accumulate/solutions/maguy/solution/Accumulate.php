<?php

declare(strict_types=1);

function accumulate(array $input, callable $accumulator): array
{
    $output = [];
    
    foreach ($input as $value){
        $output[] =  $accumulator($value);
    }

    return $output;
}
