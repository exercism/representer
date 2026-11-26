<?php

class LuckyNumbers
{
    public function sumUp(array $digitsOfNumber1, array $digitsOfNumber2): int
    {    
        $num1= (int)implode("",$digitsOfNumber1);
        $num2= (int)implode("",$digitsOfNumber2);
        return $num1 + $num2;
        // throw new \BadFunctionCallException("Implement the function");
    }

    public function isPalindrome(int $number): bool
    {
        $string = (string ) $number;
        $rev = strrev($string);
        return $string == $rev;
        // throw new \BadFunctionCallException("Implement the function");
    }

    public function validate(string $input): string
    {
         $input = trim ($input);
         if(empty($input) && $input !== "0"){
             return "Required field";
         }
        $int = (int) $input;
        if($int < 1){
            return "Must be a whole number larger than 0";
        }
        return "";
        // throw new \BadFunctionCallException("Implement the function");
    }
}
