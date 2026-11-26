<?php
declare (strict_types = 1);

class BeerSong
{
    public function verse(int $number): string
    {
        $bottles = $this->getBottlePhrase($number);
        $nextNumber = ($number === 0) ? 99 : $number - 1;
        $nextBottles = $this->getBottlePhrase($nextNumber);

        return ucfirst("$bottles of beer on the wall, $bottles of beer.\n") .
            ($number === 0 ? "Go to the store and buy some more, $nextBottles of beer on the wall."
                           : "Take " . ($number === 1 ? "it" : "one") .
                             " down and pass it around, $nextBottles of beer on the wall.\n");
    }

    public function verses(int $start, int $finish): string
    {
        $verses = [];
        for ($i = $start; $i >= $finish; $i--) {
            $verses[] = $this->verse($i);
        }
        return implode("\n", $verses);
    }

    public function lyrics(): string
    {
        return $this->verses(99, 0);
    }

    private function getBottlePhrase(int $number): string
    {
        switch ($number) {
            case 0:
                return "no more bottles";
            case 1:
                return "1 bottle";
            default:
                return "$number bottles";
        }
    }
}
