<?php

function isPangram(string $sentence): bool
{
    return empty(
        array_diff(
            range('a', 'z'),
            str_split(strtolower($sentence))
        )
    );
}
