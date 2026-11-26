<?php

function language_list(...$list)
{
    return $list;
    // implement the language list function
}

function add_to_language_list($list, $new)
{
    return array_merge($list, [$new]);
}

function prune_language_list($list)
{
    array_shift($list);
    return $list;
}

function current_language($list)
{
    return $list[1];
}

function language_list_length($list)
{
    return count($list);
}