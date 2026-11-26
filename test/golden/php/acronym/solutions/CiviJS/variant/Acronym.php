<?php


declare(strict_types=1);

function acronym(string $text): string
{
    $acronyms = '';
    if($text[0] != ' '){
        $acronyms .= $text[0];
    }
    for($i = 1; $i < (strlen($text)-1); $i++)
        {
          if(($text[$i] != ' ' || $text[$i] == '-') && $text[$i+1] !== ' ' && $text[$i+1] !== '-'){
                $acronyms .= $text[$i+1];

            }
        }
    return strtoupper($acronyms);
}
