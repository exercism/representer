<?php

declare(strict_types=1);

class Proverb
{
    public function recite(array $words)
    {
        $proverb = [];

        if (count($words) === 0) return $proverb;
        
        for ($i = 0; $i < count($words) - 1; $i++)
        {
            $proverb[] = "For want of a " . $words[$i] . " the " . $words[$i+1] . " was lost.";           
        }
   
        $proverb[] = "And all for the want of a " . $words[0] . ".";
        return $proverb;
    }
        
}

