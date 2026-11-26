<?php

class HighSchoolSweetheart
{
    public function firstLetter(string $name): string
    {
        return mb_substr(trim($name), 0, 1);
        throw new \BadFunctionCallException("Implement the function");
    }

    public function initial(string $name): string
    {
        return mb_substr(strtoupper($name), 0, 1) . ".";
        throw new \BadFunctionCallException("Implement the function");
    }

    public function initials(string $name): string
    {
        $palabras = explode(" ", $name);
        $soloDoe = mb_substr($palabras[1], 0, 1);
       
        return $this->initial(trim($name)) . " " . trim($soloDoe) . ".";
        throw new \BadFunctionCallException("Implement the function");
    }

    public function pair(string $sweetheart_a, string $sweetheart_b): string
    {
        $param_a = explode(" ", $sweetheart_a);
        $param_b = explode(" ", $sweetheart_b);
        $result_a = "";
        $result_b = "";        

        foreach($param_a as $params_a) {
            $result_a .= mb_substr(strtoupper(trim($params_a)), 0, 1) . ". ";
        }

        foreach($param_b as $params_b) {
            $result_b .= mb_substr(strtoupper(trim($params_b)), 0, 1) . ". ";
        }

        return <<<EXPECTED_HEART
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     A. B.  +  C. D.     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    EXPECTED_HEART
        ;    
        
        throw new \BadFunctionCallException("Implement the function");
    }
}

$sweetheart = new HighSchoolSweetheart();
$sweetheart->firstLetter("Jane Doe");

$sweetheart->initial("Jane Doe");

$sweetheart->initials("Jane Doe");

$sweetheart->initials("Blake Miller", "Riley Lewis");



