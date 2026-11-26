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

class Sublist
{
    public function compare(array $listOne, array $listTwo): string
    {
        if ($listOne === $listTwo) {
            return "EQUAL";
        } elseif ($listOne === []) {
            return "SUBLIST";
        } elseif ($listTwo === []) {
            return "SUPERLIST";
        }

        $lengthOne = count($listOne);
        $lengthTwo = count($listTwo);
        if ($lengthOne <= $lengthTwo) {
            $isOneBigger = false;
            $smaller = $listOne;
            $bigger = $listTwo;
        } else {
            $isOneBigger = true;
            $smaller = $listTwo;
            $bigger = $listOne;
        }
        $bigger_length = count($bigger);
        $smaller_length = count($smaller);
        for ($i = 0; $i <= $bigger_length - $smaller_length; $i++) {
            $sub = array_slice($bigger, $i, $smaller_length);
            if ($sub === $smaller) {
                return $isOneBigger ? "SUPERLIST" : "SUBLIST";
            }
        }
        return "UNEQUAL";
    }
}