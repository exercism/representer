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
    private $series_length = 0;
    
    function __construct(public string $digit_series)
    {
        if ( preg_match('/[^\p{N}]/', $digit_series) ) {
            throw new InvalidArgumentException("Input series must consist solely of digits");
        }
        
        $this->series_length = strlen($digit_series);
    }
    
    public function largestProduct(int $span): int
    {
        if ( $span > $this->series_length ) {
            throw new InvalidArgumentException("Span cannot exceed series length");
        }
        if ( $span < 0 ) {
            throw new InvalidArgumentException("Span cannot be negative");
        }
        
        $largest_product = 0;
        
        for ( $i = 0; $i + $span <= $this->series_length; $i += 1 ) {
            $span_product = array_product( str_split( substr($this->digit_series, $i, $span) ) );
            $largest_product = ( $span_product > $largest_product ) ? $span_product : $largest_product;
        }

        return $largest_product;
    }
}
