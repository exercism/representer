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

class Series
{
    private array $digits;

    public function __construct(string $digits)
    {
        if (!empty($digits) && !ctype_digit($digits)) {
            throw new InvalidArgumentException("invalid characters in digits");
        }
        $this->digits = empty($digits) ? [] : str_split($digits);
    }

    public function largestProduct(int $span): int
    {
        if ($span < 0 || $span > count($this->digits)) {
            throw new InvalidArgumentException("span must be between 0 and string length");
        }
        return max (
            array_map(
                fn($series) => array_product($series),
                $this->sliding($span)
            )
        );        
    }

    private function sliding(int $span): array
    {
        return array_map(
            fn($i) => array_slice($this->digits, $i, $span),
            range(0, count($this->digits) - $span)
        );
    }
}
