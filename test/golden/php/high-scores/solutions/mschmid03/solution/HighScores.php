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

class HighScores
{
    public array $scores;
    public int $latest;
    public int $personalBest;
    public array $personalTopThree;
    public array $sortedScoreboard;
    
    public function __construct(array $scores)
    {
        $this->scores = $scores;
        
        //Last added score (latest)
        $this->latest = end($scores);

        //Sorted Scoreboard
        $this->sortedScoreboard = $this->sortScores($scores);
        
        //Personal best
         $this->personalBest = $this->sortedScoreboard[0];
        //Personel Top three
        $this->personalTopThree = $this->getTopThree();
    }

    //Write sort function
    public function sortScores(array $scores): array
    {
        //Sort array scores, highest come first.
        usort($scores, function ($a, $b) {
            if ($a < $b) {
                return 1;
            }
            if ($a > $b) {
                return -1;
            }
            else {
                return 0;
            }
        });
        
        return $scores;
    }
    
    
    //The highest (personalBest)

    //The highest three (personalTopThree)
    public function getTopThree() 
    {
        if (!array_key_exists(1, $this->sortedScoreboard)) {
            
            return $this->sortedScoreboard;
        }
        if (!array_key_exists(2, $this->sortedScoreboard)) {
           
            return [$this->sortedScoreboard[0], $this->sortedScoreboard[1]];
            }
        return [$this->sortedScoreboard[0], $this->sortedScoreboard[1], $this->sortedScoreboard[2]];
    }
}
