<?php

class HighSchoolSweetheart
{
    public function firstLetter(string $name): string
    {
        return trim($name)[0];
    }

    public function initial(string $name): string
    {
        return strtoupper($this->firstLetter($name)) . ".";
    }

    public function initials(string $name): string
    {
        $arr = explode(" ", $name);
        return $this->initial($arr[0]) . " " . $this->initial($arr[1]);
    }

    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $initial_1 = $this->initials($sweetheart_a);
        $initial_2 = $this->initials($sweetheart_b);
        return <<<HEART
                 ******       ******
               **      **   **      **
             **         ** **         **
            **            *            **
            **                         **
            **     $initial_1  +  $initial_2     **
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
