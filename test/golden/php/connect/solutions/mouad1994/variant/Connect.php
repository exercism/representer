<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

function winner(array $lines): ?string {
    $rows = [];
    foreach ($lines as $line) {
        $trimmedLine = trim($line);
        if ($trimmedLine === '') {
            $cells = [];
        } else {
            $cells = preg_split('/\s+/', $trimmedLine);
        }
        $rows[] = $cells;
    }

    $rowsCount = count($rows);
    if ($rowsCount === 0) {
        return null;
    }

    $blackWins = false;
    $whiteWins = false;

    $queueBlack = new SplQueue();
    $visitedBlack = [];
    foreach ($rows as $i => $row) {
        if (count($row) === 0) continue;
        if ($row[0] === 'X') {
            $key = $i . ',0';
            $visitedBlack[$key] = true;
            $queueBlack->enqueue([$i, 0]);
        }
    }

    while (!$queueBlack->isEmpty()) {
        list($i, $j) = $queueBlack->dequeue();
        $currentRow = $rows[$i];
        $colsCurrentRow = count($currentRow);
        if ($j === $colsCurrentRow - 1) {
            $blackWins = true;
            break;
        }

        $neighbors = [
            [$i - 1, $j],    
            [$i - 1, $j + 1],  
            [$i, $j - 1],      
            [$i, $j + 1],      
            [$i + 1, $j - 1], 
            [$i - 1, $j],      
        ];

        foreach ($neighbors as $n) {
            $ni = $n[0];
            $nj = $n[1];
            if ($ni >= 0 && $ni < $rowsCount) {
                $nRow = $rows[$ni];
                $nCols = count($nRow);
                if ($nj >= 0 && $nj < $nCols && $nRow[$nj] === 'X') {
                    $key = $ni . ',' . $nj;
                    if (!isset($visitedBlack[$key])) {
                        $visitedBlack[$key] = true;
                        $queueBlack->enqueue([$ni, $nj]);
                    }
                }
            }
        }
    }

    $queueWhite = new SplQueue();
    $visitedWhite = [];
    if (count($rows[0]) > 0) {
        foreach ($rows[0] as $j => $cell) {
            if ($cell === 'O') {
                $key = "0,$j";
                $visitedWhite[$key] = true;
                $queueWhite->enqueue([0, $j]);
            }
        }
    }

    while (!$queueWhite->isEmpty()) {
        list($i, $j) = $queueWhite->dequeue();
        if ($i === $rowsCount - 1) {
            $whiteWins = true;
            break;
        }

        $neighbors = [
            [$i - 1, $j],      
            [$i - 1, $j + 1],  
            [$i, $j - 1],      
            [$i, $j + 1],      
            [$i + 1, $j - 1],  
            [$i + 1, $j],    
        ];

        foreach ($neighbors as $n) {
            $ni = $n[0];
            $nj = $n[1];
            if ($ni >= 0 && $ni < $rowsCount) {
                $nRow = $rows[$ni];
                $nCols = count($nRow);
                if ($nj >= 0 && $nj < $nCols && $nRow[$nj] === 'O') {
                    $key = $ni . ',' . $nj;
                    if (!isset($visitedWhite[$key])) {
                        $visitedWhite[$key] = true;
                        $queueWhite->enqueue([$ni, $nj]);
                    }
                }
            }
        }
    }

    if ($blackWins) {
        return 'black';
    } elseif ($whiteWins) {
        return 'white';
    } else {
        return null;
    }
}
