<?php

declare(strict_types=1);

function crypto_square(string $plaintext)
{
    $plaintext = strtolower($plaintext);
    $plaintext = preg_replace("/[^a-z0-9]/", "", $plaintext);

    if(strlen($plaintext) < 1) {
        return "";
    }

    $n = strlen($plaintext);
    $columns = ceil(sqrt($n));
    $rows = $n > $columns * ($columns - 1) ? $columns : $columns - 1;

    $chunks = [];
    $acc = '';
    for ($i = 0; $i < $n; $i++) {
        $acc .= $plaintext[$i];
        if ($i != 0 && $i % $columns == $columns - 1) {
            $chunks[] = $acc;
            $acc = '';
        }
    }

    if ($acc !== '') {
        while(strlen($acc) < $columns){
            $acc .= ' ';
        }
        $chunks[] = $acc;
    }

    $result = '';
    for ($i = 0; $i < $columns; $i++) {
        for ($j = 0; $j < count($chunks); $j++) {
            $result .= $chunks[$j][$i] ?? " ";
        }
        if ($i != $columns - 1) {
            $result .= " ";
        }
    }

    return $result;
}

