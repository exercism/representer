<?php

declare(strict_types=1);

class Game
{
    private array $rolls = [];

    public function score(): int
    {
        if (!$this->isGameComplete()) {
            throw new Exception("The game is not complete.");
        }
        $score = 0;
        $position = 0;
        for ($frame = 0; $frame < 10; $frame++) {
            if ($this->isStrike($position)) {
                $score +=
                    10 +
                    $this->rolls[$position + 1] +
                    $this->rolls[$position + 2];
                $position++;
                continue;
            }
            if ($this->isSpare($position)) {
                $score += 10 + $this->rolls[$position + 2];
                $position += 2;
                continue;
            }
            $score += $this->rolls[$position] + $this->rolls[$position + 1];
            $position += 2;
        }
        return $score;
    }
    
    public function roll(int $pins): void
    {
        if ($pins < 0 || $pins > 10) {
            throw new Exception("Pins must be between 0 and 10.");
        }
        if ($this->isGameComplete()) {
            throw new Exception("The game is already complete.");
        }
        $this->rolls[] = $pins;
        $this->validateLastFrame();
    }
    
    private function isStrike(int $position): bool
    {
        return $this->rolls[$position] === 10;
    }
    
    private function isSpare(int $position): bool
    {
        return $this->rolls[$position] + $this->rolls[$position + 1] === 10;
    }
    
    private function isGameComplete(): bool
    {
        $position = 0;
        for ($frame = 1; $frame <= 10; $frame++) {
            if (!isset($this->rolls[$position])) {
                return false;
            } // Strike
            if ($this->rolls[$position] === 10) {
                $position++;
                if ($frame === 10) {
                    return isset($this->rolls[$position + 1]);
                }
                continue;
            } // Need second roll
            if (!isset($this->rolls[$position + 1])) {
                return false;
            }
            $frameScore = $this->rolls[$position] + $this->rolls[$position + 1];
            if ($frameScore > 10) {
                throw new Exception("A frame cannot score more than 10 pins.");
            } // Spare in frame 10 needs one bonus roll
            if ($frame === 10 && $frameScore === 10) {
                return isset($this->rolls[$position + 2]);
            } // Open frame 10 is complete
            if ($frame === 10) {
                return true;
            }
            $position += 2;
        }
        return false;
    }
    
    private function validateLastFrame(): void
    {
        $position = 0;
    
        for ($frame = 1; $frame < 10; $frame++) {
            if (!isset($this->rolls[$position])) {
                return;
            }
        
            // Strike
            if ($this->rolls[$position] === 10) {
                $position++;
                continue;
            }
        
            if (!isset($this->rolls[$position + 1])) {
                return;
            }
        
            if ($this->rolls[$position] + $this->rolls[$position + 1] > 10) {
                throw new Exception('A frame cannot score more than 10 pins.');
            }
        
            $position += 2;
        }
    
        if (!isset($this->rolls[$position])) {
            return;
        }
    
        $first = $this->rolls[$position];
    

        if ($first === 10) {
            if (!isset($this->rolls[$position + 1])) {
                return;
            }
        
            $second = $this->rolls[$position + 1];
        
            if (!isset($this->rolls[$position + 2])) {
                return;
            }
        
            $third = $this->rolls[$position + 2];
        
            if ($second !== 10 && $second + $third > 10) {
                throw new Exception('Bonus rolls cannot score more than 10 pins.');
            }
        
            if ($second !== 10 && $third === 10) {
                throw new Exception(
                    'The second bonus roll cannot be a strike when the first bonus roll was not a strike.'
                );
            }
        
            // A strike in frame 10 allows exactly two bonus rolls.
            if (isset($this->rolls[$position + 3])) {
                throw new Exception('A strike can only have two bonus rolls.');
            }
        
            return;
        }
    
        if (!isset($this->rolls[$position + 1])) {
            return;
        }
    
        $second = $this->rolls[$position + 1];
        $frameScore = $first + $second;
    
        if ($frameScore > 10) {
            throw new Exception('A frame cannot score more than 10 pins.');
        }
    
        if ($frameScore === 10) {
            if (!isset($this->rolls[$position + 2])) {
                return;
            }
        
            if (isset($this->rolls[$position + 3])) {
                throw new Exception('A spare can only have one bonus roll.');
            }
        
            return;
        }
    
        if (isset($this->rolls[$position + 2])) {
            throw new Exception('An open frame cannot have bonus rolls.');
        }
    }
}
