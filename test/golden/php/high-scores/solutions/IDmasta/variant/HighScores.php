<?php

declare(strict_types=1);

class HighScores
{
    public $scores = [];
    public $latest = [];
    public $personalBest = [];
    public $personalTopThree = [];
    
    public function __construct(array $input)
    {
        $this->scores = $input;

        $this->latest = $this->Latest($input);

        $this->personalBest = $this->PersonalBest($input);

        $this->personalTopThree = $this->PersonalTopThree($input);

    }

    public function Latest($input)
    {
        return $input[array_key_last($input)];
    }

    public function PersonalBest($input)
    {
        rsort($input);
        return (int)$input[0];
    }

    public function PersonalTopThree($input)
    {
        $result = [];
        rsort($input);
        
        if (count($input) < 3 || count($input) !== 1) {
            for ($i = 0; $i <= 1; $i++) {
                $result[] = $input[$i];
            }
        } elseif(count($input) == 1) {
            $result[] = $input[0];
        } else {
            for ($i = 0; $i <= 2; $i++) {
                $result[] = $input[$i];
            }
        }
        return $result;
    }

}
