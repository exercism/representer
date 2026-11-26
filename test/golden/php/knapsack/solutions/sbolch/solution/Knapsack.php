<?php

declare(strict_types=1);

class Knapsack
{
    public function getMaximumValue(int $maximumWeight, array $items): int
    {
        $maxval = array_fill(0, $maximumWeight + 1, 0);
        foreach ($items as $item) {
            for ($weight = $maximumWeight; $weight >= $item['weight']; $weight--) {
                $maxval[$weight] = max($maxval[$weight], $maxval[$weight - $item['weight']] + $item['value']);
            }
        }
        return $maxval[$maximumWeight];
    }
}
