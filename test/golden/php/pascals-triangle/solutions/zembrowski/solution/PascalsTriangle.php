<?php

function pascalsTriangleRows(?int $size): array | int
{
    if ($size === null || $size < 0) {
        return -1;
    }

    $rows = [];

    for ($r = 0; $r < $size; $r++) {
        $row = [1];

        $previousRow = $rows[$r - 1] ?? [];
        $previousSize = count($previousRow);

        for ($c = 1; $c <= $previousSize; $c++) {
            if ($c === $previousSize) {
                $row[] = 1;
                continue;
            }

            $row[] = ($previousRow[$c - 1] + $previousRow[$c]);
        }

        $rows[] = $row;
    }

    return $rows;
}
