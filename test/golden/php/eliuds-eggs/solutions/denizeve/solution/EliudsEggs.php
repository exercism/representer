<?php

declare(strict_types=1);

class EliudsEggs
{
    public function eggCount(int $displayValue): int
    {
        $count = 0;
        while ($displayValue > 0) {
            $count += $displayValue & 1;
            $displayValue >>= 1;
        }
        return $count;
    }
}
