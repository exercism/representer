<?php

declare(strict_types=1);

class Game
{
    private array $rolls = [];

    public function roll(int $pins): void
    {
        if ($pins < 0) {
            throw new RuntimeException('Cannot be less than 0');
        }
        if ($pins > 10) {
            throw new RuntimeException('Cannot be more than 10');
        }

        $this->rolls[] = $pins;
    }

    public function score(): int
    {
        $score = 0;
        $frameIndex = 0;
        for ($frame = 1; $frame <= 10; $frame++) {
            if (!isset($this->rolls[$frameIndex])) {
                throw new RuntimeException('Cannot score incomplete game');
            }
            if ($this->isStrike($frameIndex)) {
                $score += 10 + $this->strikeScore($frameIndex);
                $frameIndex++;
            } else if ($this->isSpare($frameIndex)) {
                $score += 10 + $this->spareScore($frameIndex);
                $frameIndex += 2;
            } else {
                $score += $this->scoreRolls($frameIndex);
                $frameIndex += 2;
            }
        }
        $this->checkTooManyFrames($frameIndex);

        return $score;
    }

    private function isStrike(int $index): bool
    {
        return $this->rolls[$index] === 10;
    }

    private function strikeScore(int $frameIndex): int
    {
        if (!isset($this->rolls[$frameIndex + 1], $this->rolls[$frameIndex + 2])) {
            throw new RuntimeException('Cannot score incomplete game');
        }

        $bonus1 = $this->rolls[$frameIndex + 1];
        $bonus2 = $this->rolls[$frameIndex + 2];

        $sum = $bonus1 + $bonus2;
        if ($sum > 10 && $frameIndex !== 10 && $bonus1 !== 10) {
            throw new RuntimeException('Those extra pins were not standing');
        }
        return $sum;
    }

    private function isSpare(int $frameIndex): bool
    {
        return $this->rolls[$frameIndex] + $this->rolls[$frameIndex + 1] === 10;
    }

    private function spareScore(int $frameIndex)
    {
        if (!isset($this->rolls[$frameIndex + 2])) {
            throw new RuntimeException('Incomplete spare check: ' . $frameIndex );
        }

        return $this->rolls[$frameIndex + 2];
    }

    private function scoreRolls(int $frameIndex)
    {
        if (!isset($this->rolls[$frameIndex + 1])) {
            throw new RuntimeException('Incomplete game');
        }

        $sum = $this->rolls[$frameIndex] + $this->rolls[$frameIndex + 1];
        if ($sum > 10) {
            throw new RuntimeException('Cannot hit same pin more than once');
        }
        return $sum;
    }

    private function checkTooManyFrames(int $frameIndex): void
    {
        $rolls = count($this->rolls);
        if ($this->isStrike($frameIndex-1)) {
            if ($rolls > $frameIndex + 2) {
                throw new RuntimeException('Too many frames');
            }
        } elseif ($this->isSpare($frameIndex - 2)) {
            if ($rolls > $frameIndex + 1) {
                throw new RuntimeException('Too many frames');
            }
        } elseif ($rolls > $frameIndex) {
            throw new RuntimeException('Too many frames');
        }
    }
}
