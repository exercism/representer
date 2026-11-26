<?php

declare(strict_types=1);

function flatten(array $input): array
{
    $res = [];
    foreach ($input as $inp) {
        if (is_array($inp)) {
            $res = array_merge($res, flatten($inp));
        } elseif ($inp !== null) {
            $res[] = $inp;
        }
    }
    return $res;
}
