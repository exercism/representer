<?php

declare (strict_types = 1);

class Bob
{
    /**
     * Responds to the given string.
     *
     * @param string $str The input string.
     *
     * @return string The response based on the input.
     */
    public function respondTo(string $str)
    {
        $str = trim($str, " \n\t\r\u{000b}\u{00a0}\u{2002}");

        if ($this->isQuestion($str)) {
            return $this->isYelling($str) ?
            "Calm down, I know what I'm doing!" :
            "Sure.";
        }

        if ($this->isYelling($str)) {
            return "Whoa, chill out!";
        }

        return empty($str) ? "Fine. Be that way!" : "Whatever.";
    }

    /**
     * Checks if the given string is yelling (all uppercase).
     *
     * @param string $str The input string.
     *
     * @return bool True if the input is yelling, false otherwise.
     */
    private function isYelling(string $str): bool
    {
        return preg_match('/\p{L}/', $str) && mb_strtoupper($str) == $str;
    }

    /**
     * Checks if the given string is a question.
     *
     * @param string $str The input string.
     *
     * @return bool True if the input is a question, false otherwise.
     */
    private function isQuestion(string $str): bool
    {
        return preg_match('/\?$/', $str) === 1;
    }

}
