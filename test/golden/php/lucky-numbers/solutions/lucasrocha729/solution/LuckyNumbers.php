<?php

class LuckyNumbers
{
    public function sumUp(array $digitsOfNumber1, array $digitsOfNumber2): int
    {
        $digitsFirstList = (int) implode("", $digitsOfNumber1);
        $digitsSecondList = (int) implode("", $digitsOfNumber2);

        return $digitsFirstList + $digitsSecondList;
    }

    public function isPalindrome(int $number): bool
    {
        $parsedToString = (string) $number;
        $reverse = strrev($parsedToString);
        return $parsedToString == $reverse;
    }

    public function validate(string $input): string
    {
        $input = trim ($input);
        
        if (empty($input) && $input !== "0") {
            return "Required field";
        }
        
        $int = (int) ($input);
        
        if ($int < 1) {
            return "Must be a whole number larger than 0";
        }
            return "";
        }
}
