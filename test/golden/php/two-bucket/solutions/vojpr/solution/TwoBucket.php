<?php

declare(strict_types=1);

class TwoBucket
{
    public int $numberOfActions = 0;
    public ?string $nameOfBucketWithDesiredLiters = null;
    public int $litersLeftInOtherBucket = 0;
    private array $generations = [0 => [[0, 0]]];
    private array $ignoredPairs = [[0, 0]];
    private bool $isSolved = false;

    public function solve(int $sizeBucketOne, int $sizeBucketTwo, int $goal, string $startBucket): self
    {
        $this->checkIfSolvable($sizeBucketOne, $sizeBucketTwo, $goal);
        $this->ignoredPairs[] = $startBucket === "one" ? [0, $sizeBucketTwo] : [$sizeBucketOne, 0];

        while(!$this->isSolved) {
            $this->numberOfActions++;
            $this->generations[$this->numberOfActions] = [];

            foreach ($this->generations[$this->numberOfActions - 1] as $bucketPair) {
                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->pourOneBucketToTheOther($bucketPair[0], $sizeBucketOne, $bucketPair[1], $sizeBucketTwo), $goal);
                }

                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->pourOneBucketToTheOther($bucketPair[0], $sizeBucketOne, $bucketPair[1], $sizeBucketTwo, false), $goal);
                }

                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->emptyBucket($bucketPair), $goal);
                }

                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->emptyBucket($bucketPair, false), $goal);
                }

                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->fillBucket($bucketPair, $sizeBucketOne, $sizeBucketTwo), $goal);
                }

                if (!$this->isSolved) {
                    $this->checkForBucketPair($this->fillBucket($bucketPair, $sizeBucketOne, $sizeBucketTwo, false), $goal);
                }
            }
        }

        return $this;
    }

    private function pourOneBucketToTheOther(int $littersInBucketA, int $sizeOfBucketA, int $littersInBucketB, int $sizeOfBucketB, bool $pourAToB = true): ?array
    {
        $emptyLitersInBucket = $pourAToB ? ($sizeOfBucketB - $littersInBucketB) : ($sizeOfBucketA - $littersInBucketA);
        $litersToBePoured = $pourAToB ? min($littersInBucketA, $emptyLitersInBucket) : min($littersInBucketB, $emptyLitersInBucket);
        $newPair = $pourAToB ? [$littersInBucketA - $litersToBePoured, $littersInBucketB + $litersToBePoured] : [$littersInBucketA + $litersToBePoured, $littersInBucketB - $litersToBePoured];

        return in_array($newPair, $this->ignoredPairs) ? null : $newPair;
    }

    private function emptyBucket(array $bucketPair, bool $emptyFirst = true): ?array
    {
        $newPair = $emptyFirst ? [0, $bucketPair[1]] : [$bucketPair[0], 0];

        return in_array($newPair, $this->ignoredPairs) ? null : $newPair;
    }

    private function fillBucket(array $bucketPair, int $sizeBucketOne, int $sizeBucketTwo, bool $fillFirst = true): ?array
    {
        $newPair = $fillFirst ? [$sizeBucketOne, $bucketPair[1]] : [$bucketPair[0], $sizeBucketTwo];

        return in_array($newPair, $this->ignoredPairs) ? null : $newPair;
    }

    private function checkIfSolvable(int $sizeBucketOne, int $sizeBucketTwo, int $goal): void
    {
        $a = max($sizeBucketOne, $sizeBucketTwo);
        $b = min($sizeBucketOne, $sizeBucketTwo);

        while ($b !== 0) {
            $temp = $b;
            $b = $a % $b;
            $a = $temp;
        }
        $greatestCommonDivisor = $a;

        if ($goal > max($sizeBucketOne, $sizeBucketTwo) || $goal % $greatestCommonDivisor !== 0) {
            throw new Exception();
        }
    }

    private function isCorrectSolution(array $bucketPair, int $goal): bool
    {
        if (in_array($goal, $bucketPair)) {
            $this->nameOfBucketWithDesiredLiters = $goal === $bucketPair[0] ? "one" : "two";
            $this->litersLeftInOtherBucket = $goal === $bucketPair[0] ? $bucketPair[1] : $bucketPair[0];

            return true;
        }

        return false;
    }

    private function checkForBucketPair(?array $bucketPair, int $goal): void
    {
        if ($bucketPair !== null) {
            $this->ignoredPairs[] = $bucketPair;
            $this->generations[$this->numberOfActions][] = $bucketPair;
            $this->isSolved = $this->isCorrectSolution(end($this->generations[$this->numberOfActions]), $goal);
        }
    }
}