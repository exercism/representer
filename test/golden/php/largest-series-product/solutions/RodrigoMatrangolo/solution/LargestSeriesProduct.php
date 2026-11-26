<?php


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

        return max(
            array_map(
                fn ($series) => array_product($series),
                $this->series($span)
            )
        );
    }

    private function series(int $span): array
    {
        return array_map(
            fn ($i) => array_slice($this->digits, $i, $span),
            range(0, count($this->digits) - $span)
        );
    }
}
