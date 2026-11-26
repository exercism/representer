<?php

declare(strict_types=1);

function diamond(string $letter): array
{
    $asc = ord($letter);
    $results = [];

    $outer_spaces = $asc - 65;
    $inner_spaces = 0;
    for ($i = 65; $i <= $asc; $i++) 
    {
        $side = "";
        $middle = chr($i);
        while ($outer_spaces > 0) {
            $side .= " ";
            $outer_spaces--;
        }
        while ($inner_spaces > 0) {
            $middle .= " ";
            $inner_spaces--;
        }

        $outer_spaces = $asc - $i - 1;
        $inner_spaces = 2 * ($i + 1 - 65) - 1;
        if ($inner_spaces > 1)
            $middle .= chr($i);
        
        array_push($results, $side.$middle.$side);
    }

    for ($i = count($results) - 2; $i >= 0; $i--)
        array_push($results, $results[$i]);

    return $results;
}