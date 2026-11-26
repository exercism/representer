<?php

declare(strict_types=1);

function findFewestCoins(array $coins, int $amount): array
{
    if ($amount < 0) {
        throw new InvalidArgumentException("Cannot make change for negative value");
    }
    if ($amount == 1) {
        return [1];
    } else if ($amount == 0) {
        return [];
    }

    $anything_small_enough = false;
    
    $change = array_fill(0, $amount + 1, $amount + 1);
    $change[0] = 0;

    $last_coin = array_fill(0, $amount + 1, -1);

    for ($i = 1; $i <= $amount; $i++) {
        foreach ($coins as $coin) {
            if ($i - $coin >=0 && $change[$i + $coin] + 1 < $change[$i]) {
                $change[$i] = $change[$i-$coin] + 1;
                $last_coin[$i] = $coin;
                $anything_small_enough = true;
            }
            
        }
    }

    if (!$anything_small_enough) {
        throw new InvalidArgumentException("No coins small enough to make change");
    }
    if ($change[$amount] > $amount && $last_coin[$amount] == -1) {
        throw new InvalidArgumentException("No combination can add up to target");
    }
    
    $result = [];
    $curr = $amount;

    while ($curr > 0) {
        $coin = $last_coin[$curr];
        $result[] = $coin;
        $curr -= $coin;
    }

    return $result;
    
    throw new \BadFunctionCallException("Implement the findFewestCoins function");
}
