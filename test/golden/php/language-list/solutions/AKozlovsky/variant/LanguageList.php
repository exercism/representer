<?php

function language_list(...$arr)
{
    if ($arr) {
        return (array) $arr;
    } else {
        return [];
    }
}

function add_to_language_list($arr, $str)
{
    array_push($arr, $str);

    return $arr;
}

function prune_language_list($arr)
{
    array_pop($arr);

    return $arr;
}

function current_language($arr)
{
    return current($arr);
}

function language_list_length($arr)
{
    return count($arr);
}
