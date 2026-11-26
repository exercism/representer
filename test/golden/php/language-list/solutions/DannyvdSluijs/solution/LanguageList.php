<?php

function language_list(string ...$languages): array
{
    return $languages;
}

function add_to_language_list(array $list, string $language): array
{
    return [...$list, $language];
}

function prune_language_list(array $list): array
{
    return array_slice($list, 1);
}

function current_language(array $list): string
{
    return array_shift($list);
}

function language_list_length(array $list): int
{
    return count($list);
}