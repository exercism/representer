<?php

class HighSchoolSweetheart
{
    public function firstLetter(string $name): string
    {
        $str = str_replace(" ","",$name);
        return $str[0];
    }

    public function initial(string $name): string
    {
        $str = strtoupper($this->firstLetter($name));
        return $str.".";
    }

    public function initials(string $name): string
    {
        $str = explode(" ", $name);
        return $this->initial($str[0]) . " " . $this->initial($str[2]);
    }

    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $center = "**     ".$this->initials($sweetheart_a)."  +  ".$this->initials($sweetheart_b)."     **";
    
        return <<<HEART
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    $center
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    HEART;
    }

}
