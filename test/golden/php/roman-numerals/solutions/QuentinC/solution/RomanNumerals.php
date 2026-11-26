<?php

declare(strict_types=1);

function romanLiterals(): array
{
    return array(1000=>"M", 900=>"CM", 500=>"D", 400=>"CD", 100=>"C", 90=>"XC", 50=>"L", 40=>"XL", 10=>"X", 9=>"IX", 5=>"V", 4=>"IV", 1=>"I");
}

function toRoman(int $number): string
{
    $roman = "";
    foreach (romanLiterals() as $num => $literal) {
        while ($number >= $num) {
            $roman .= $literal;
            $number -= $num;
        }
    }
    return $roman;
}
