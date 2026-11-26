<?php

class HighSchoolSweetheart{
    public function firstLetter($name){
      return substr(trim($name), 0, 1);
    }
    
    public function initial($name){
      return strtoupper($this->firstLetter($name)) . ".";
    }

    public function initials($name){
      $names = explode(" ", $name);
      return $this->initial($names[0]) . " " . $this->initial($names[1]);
    }
    public function pair($nameA,$nameB){
      $initA = $this->initials($nameA);
      $initB = $this->initials($nameB);
       $text = 
"     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     $initA  +  $initB     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *";
      return $text;
    }
  }
