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
    /*
    ** @property array<int> $scores
    ** @property int $latest
    ** @property int $personalBest
    ** @property array<int> $personalTopThree
    */
    public $scores = [];
    public $latest = NULL;
    public $personalBest = NULL;
    public $personalTopThree = [];
    
    public function __construct(array $scores)
    {
        if (count($scores) > 0) {
            $this->scores = $scores;
            $this->latest = end($scores);
            $this->personalBest = max($scores);

            $this->setTopThree($scores);
        }
    }

    private function setTopThree(array $scores): void
    {
        $number_of_scores = count($scores);

        // add high score to personal top 3
        $this->personalTopThree[] = $this->personalBest;

        // find up to two next highest scores if they exist
        unset($scores[array_search($this->personalBest, $scores)]);
        $i = 1;
        for ($i = 1; $i < 3 && count($scores) > 0; $i += 1) {
            $next_high_score = max($scores);
            $this->personalTopThree[] = $next_high_score;
            unset($scores[array_search($next_high_score, $scores)]);   
        }
    }
}
