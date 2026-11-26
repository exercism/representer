<?php

class LuckyNumbers
{
    public function sumUp(array $digitsOfNumber1, array $digitsOfNumber2): int
    {
        $first_number = $this->arrayToNumber($digitsOfNumber1);
        $second_number = $this->arrayToNumber($digitsOfNumber2);
        return $first_number + $second_number;
    }

    public function isPalindrome(int $number): bool
    {
        $temp = $number;
        $new = 0;
        while (floor($temp)) {
            $d = $temp % 10;
            $new = $new * 10 + $d;
            $temp = $temp / 10;
        }
        return $new == $number;
    }

    public function validate(string $input): string
    {
        $trimmed_input = trim($input);
        preg_match("/^-?[0-9]+/", $trimmed_input, $matches);
        $number = $matches[0];
        if (!$number && !strlen($trimmed_input))
            return "Required field";
        if (!$number || ((int) $number) <= 0)
            return "Must be a whole number larger than 0";
        return "";
    }

    private function arrayToNumber(array $array): int
    {
        return (int) array_reduce($array, fn(string $acc, int $value) => $acc . strval($value), "");
    }
}
