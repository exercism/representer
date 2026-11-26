<?php
declare(strict_types=1);

class BeerSong
{
    public function verse(int $number): string
    {
        $next = $number - 1;
        switch($number) {
            case 0:
                return ("No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.");
            case 1:
                return ("{$number} bottle of beer on the wall, {$number} bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n");
            case 2:
                return ("{$number} bottles of beer on the wall, {$number} bottles of beer.\nTake one down and pass it around, {$next} bottle of beer on the wall.\n");
            default:
                return ("{$number} bottles of beer on the wall, {$number} bottles of beer.\nTake one down and pass it around, {$next} bottles of beer on the wall.\n");
        }
       
    }
    public function verses(int $start, int $finish): string
    {
        $song = '';
        for($i = $start; $i >= $finish; $i--) {
            $song .= $this->verse($i);
            if ($i > $finish) {
                $song .= "\n";
            }
        }
        return $song;
    }
    public function lyrics(): string
    {
        return $this->verses(99, 0);
    }
}