<?php

function language_list(...$languages): array
{
    return $languages;
}

function add_to_language_list(array $languages, $another_language)
{
    return array_merge($languages, [$another_language]);
}

function prune_language_list(array $languages)
{
    return array_slice($languages, 1);
}

function current_language(array $languages)
{
    return $languages[0];        
}

function language_list_length(array $languages): int
{
    return count($languages);
}
