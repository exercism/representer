<?php

function language_list(...$languagesList)
{
    return $languagesList;
}

function add_to_language_list($languagesList, $language)
{
    $languagesList[] = $language;
    return $languagesList;
}

function prune_language_list($languagesList)
{
    array_shift($languagesList);
    return $languagesList;
}

function current_language($languagesList)
{
    return $languagesList[0];
}

function language_list_length($languagesList)
{
    return sizeof($languagesList);
}