<?php

declare(strict_types=1);

function findFewestCoins(array $coins, int $amount): ?array
{
    if ($amount == 0) {
        return [];
    }

    if ($amount < 0) {
        throw new InvalidArgumentException('Cannot make change for negative value');
    }

    if ($amount < $coins[0]) {
        throw new InvalidArgumentException('No coins small enough to make change');
    }

    $tab = array_fill(0, $amount, null);

    for ($i = 1; $i <= $amount; $i++) {

        $possible = null;
        foreach ($coins as $coin) {
            if ($coin == $i) {
                $possible = [$coin];
                break;
            }

            if ($i - $coin < 0 || $tab[$i - $coin] === null) {
                continue;
            }
            $newPossible = array_merge([$coin], $tab[$i - $coin]);

            if (array_sum($newPossible) == $i) {
                if ($possible === null) {
                    $possible = $newPossible;

                    continue;
                }

                if (count($newPossible) < count($possible)) {
                    $possible = $newPossible;
                }
            }

        }
        $tab[$i] = $possible;

    }

    return $tab[$amount] ?? throw new InvalidArgumentException('No combination can add up to target');

}
