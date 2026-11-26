<?php

function language_list(...$language_list)
{
    return $language_list;
}

function add_to_language_list($language_list, $language)
{
    return [...$language_list, $language];
}

function prune_language_list($language_list)
    {
        return array_slice($language_list, 1);
    }

function current_language($language_list)
    {
        return $language_list[0];
    }

function language_list_length($language_list)
    {
        return count($language_list);
    }