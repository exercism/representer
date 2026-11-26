<?php

class HighSchoolSweetheart
{
    public function firstLetter(string $name): string
    {
        return trim($name)[0];
    }

    public function initial(string $name): string
    {
        return sprintf("%s.", strtoupper($this->firstLetter($name)));
    }

    public function initials(string $name): string
    {
        $initials = [];
        foreach (explode(" ", $name) as $word) {
            $initials[] = $this->initial($word);
        }

        return implode(" ", $initials);
    }

    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $initials_a = $this->initials($sweetheart_a);
        $initials_b = $this->initials($sweetheart_b);
        
        return <<<END
      ******       ******
    **      **   **      **
  **         ** **         **
 **            *            **
 **                         **
 **     $initials_a  +  $initials_b     **
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
