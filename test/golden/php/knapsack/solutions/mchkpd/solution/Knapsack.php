<?php

declare(strict_types=1);

class Knapsack
{
    public function getMaximumValue(int $maximumWeight, array $items): int
    {
        $result = array_fill(0, $maximumWeight + 1, 0);
        foreach ($items as $item) {
            for ($j = $maximumWeight; $j >= $item['weight']; $j--) {
                $result[$j] = max($result[$j], $result[$j - $item['weight']] + $item['value']);
            }
        }

        return $result[$maximumWeight];
    }
}
