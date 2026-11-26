<?php
declare (strict_types = 1);

function encode(string $input): string
{
    return preg_replace_callback('/(.)\1*/', function($match) {
        $len = strlen($match[0]);
        return ($len > 1 ? $len : '') . $match[1];
    }, $input);
}

function decode(string $input): string
{
    return preg_replace_callback('/(\d+)(\D)/', function ($match) {
        return str_repeat($match[2], intval($match[1]));
    }, $input);
}
