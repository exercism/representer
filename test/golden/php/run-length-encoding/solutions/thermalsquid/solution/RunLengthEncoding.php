<?php

declare(strict_types=1);

function dd($value)
{
    var_dump($value);
    die();
}

function encode(string $input): string
{
    if ($input === '') {
        return '';
    }

    $characters = mb_str_split($input);

    $runs = [];
    $currentRun = [];
    $previousCharacter = $characters[0];

    foreach ($characters as $character) {
        if ($character !== $previousCharacter) {
            $runs[] = $currentRun;
            $currentRun = [];
        }

        $currentRun[] = $character;
        $previousCharacter = $character;
    }

    $runs[] = $currentRun;

    return array_reduce(
        $runs,
        function ($result, $run) {
            return count($run) > 1
                ? $result.count($run).$run[0]
                : $result.$run[0];
        },
        '',
    );
}

function decode(string $input): string
{
    preg_match_all('/(\d*)([A-Za-z ])/', $input, $matches, PREG_SET_ORDER);

    $result = '';

    foreach ($matches as [, $runLengthDigits, $character]) {
        $runLength = is_numeric($runLengthDigits) ? (int) $runLengthDigits : 1;
        $result .= str_repeat($character, $runLength);
    }

    return $result;
}
