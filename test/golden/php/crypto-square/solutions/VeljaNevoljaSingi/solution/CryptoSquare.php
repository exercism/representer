<?php

declare(strict_types=1);
function crypto_square(string $plaintext): string
{
    $plaintext = strtolower(str_replace(" ", "", $plaintext));
    $plaintext = preg_replace('/[^a-z|0-9]/', "", $plaintext);
    $length = strlen($plaintext);
    $square = (int)round(sqrt($length));
    $chunks = (int)$square;
    while ($chunks * $square < $length) {
        $chunks++;
    }
    $codeArray = [];
    $whitespaceNeeded = ($square * $chunks) - $length;
    for ($a = 0; $a < $whitespaceNeeded; $a++) {
        $plaintext .= " ";
    }
    for ($i = 0; $i < $square; $i++) {
        $codeArray[$i] = substr($plaintext, 0, $chunks);
        $plaintext = substr($plaintext, $chunks);
    }
    $ans = "";
    for ($j = 0; $j < $chunks; $j++) {
        for ($k = 0; $k < count($codeArray); $k++) {
            $ans .= $codeArray[$k][0];
            $codeArray[$k] = substr($codeArray[$k], 1);
        }
    }
    $spaced = "";
    for ($b = 0; $b < $chunks; $b++) {
        $spaced .= substr($ans, 0, $square) . " ";
        $ans = substr($ans, $square);
    }
    return substr($spaced, 0, strlen($spaced) - 1);
}
