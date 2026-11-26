<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

class BeerSong
{
    public function verse(int $number): string
    {
        $bottles = sprintf( $this->myGetText(["No more bottles", "%d bottle", "%d bottles"], $number), $number);
        $last_line = $this->lastLine($number);
        
        return sprintf("%s of beer on the wall, %s of beer.\n%s", $bottles, lcfirst($bottles), $last_line); 
    }

    private function lastLine(int $number): string
    {
        $last_line_template = "Take %s down and pass it around, %s of beer on the wall.\n";
        
        return match ($number) {
            0 => "Go to the store and buy some more, 99 bottles of beer on the wall.",
            1 => sprintf($last_line_template, 'it', 'no more bottles'),
            default => $this->pluralLastLine($number, $last_line_template)
        };
    }

    /*
     * @param array<string> $formats
     * @param int $count
     * @return string
     */
    private function myGetText($formats, $count)
    {
        $largest_formats_index = count($formats) - 1;
        $normalized_count = ( $count > $largest_formats_index ) ? $largest_formats_index : $count;
        
        return $formats[$normalized_count];
    }

    private function pluralLastLine(int $number, $last_line_template): string
    {
        $take_this_down = $this->myGetText(['', 'it', 'one'], $number);
        $remaining_bottles = sprintf($this->myGetText(["no more bottles", "%d bottle", "%d bottles"], $number - 1),                                                                                                             $number - 1);
        return sprintf($last_line_template, $take_this_down , $remaining_bottles);
        
    }
    
    public function verses(int $start, int $finish): string
    {
        $verses = [];
        foreach ( range($start, $finish) as $this_verse ) {
            $verses[] = $this->verse($this_verse);
        }

        return implode("\n", $verses);
    }

    public function lyrics(): string
    {
        return $this->verses(99, 0);
    }
}
