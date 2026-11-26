<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

function score(string $word): int
{
    $score_dict =  [
        1 => ['A','E','I','O','U','L','N','R','S','T'],
        2 => ['D','G'],
        3 => ['B','C','M','P'],
        4 => ['F','H','V','W','Y'],
        5 => ['K'],
        8 => ['J','X'],
        10 => ['Q','Z']
    ];
    
    $word = strtoupper($word);//Convert 
    $score = 0;

    for ($i = 0; $i < strlen($word); $i++) {
        foreach ($score_dict as $key => $subArray) {
            if (in_array($word[$i], $subArray)) {
                 $score += $key;
            }
        }
    }
    
    return $score;
}
