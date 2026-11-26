<?php

declare(strict_types=1);
function maskify(string $cc): string
{
       if (strlen($cc) <= 6) {
        return $cc;
    }
    for ($i = 1; $i < strlen($cc) - 4; $i++) {
        if ($cc[$i] != '-') {
            $cc[$i] = '#';
        }
    }
    return $cc;
}
