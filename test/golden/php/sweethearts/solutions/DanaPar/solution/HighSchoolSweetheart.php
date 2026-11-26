<?php

class HighSchoolSweetheart
{
    public function firstLetter(string $name): string
    {
        return substr(trim($name), 0, 1);
    }

    public function initial(string $name): string
    {
        return strtoupper($this->firstLetter($name)) . ".";
    }

    public function initials(string $name): string
    {
        $names = explode(" ", $name);
        return $this->initial($names[0]) . " " . $this->initial($names[1]);
    }

    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $name1 = $this->initials($sweetheart_a);
        $name2 = $this->initials($sweetheart_b);
        return <<<END
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     {$name1}  +  {$name2}     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
END;
        
    }
}
