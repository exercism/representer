<?php

declare(strict_types=1);

class HighScores
{   
    public int $latest;
    public int $personalBest;
    public array $personalTopThree;
    
    public function __construct(public array $scores)
    {
        $this->latest = $this->getLatest();
        $this->personalBest = $this->getPersonalBest();
        $this->personalTopThree = $this->getPersonalTopThree();
    }

    private function getLatest(): int {
        return $this->scores[count($this->scores)-1];
    }

    private function getPersonalBest(): int {
        return max($this->scores);
    }

    private function getPersonalTopThree(): array {
        $sortedScores = $this->scores;
        rsort($sortedScores);
        return array_slice($sortedScores, 0, 3);
    }
}
