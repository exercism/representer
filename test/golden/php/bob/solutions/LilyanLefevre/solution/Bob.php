<?php

declare(strict_types=1);

class Bob
{
    public function respondTo(string $str): string
    {
        $trimmed_string = trim($str);
        $contains_letter = preg_match("/[a-zA-Z]+/", $trimmed_string);
        $is_all_upper = !preg_match("/[a-z]+/", $trimmed_string);
        $is_question = substr($trimmed_string, -1) == '?';
        $empty_str = $trimmed_string == '';

        if($is_all_upper && $is_question && $contains_letter) return "Calm down, I know what I'm doing!";
        if($is_all_upper && $contains_letter) return "Whoa, chill out!";
        if($is_question) return "Sure.";
        if($empty_str) return "Fine. Be that way!";
        return 'Whatever.';
    }
}
