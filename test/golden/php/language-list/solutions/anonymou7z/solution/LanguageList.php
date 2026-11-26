<?php

function language_list(...$langs): array {
    return $langs;
}

function add_to_language_list(array $langs, string $lang): array {
    $langs[] = $lang;
    return $langs;
}

function prune_language_list(array $langs): array {
    array_shift($langs);
    return $langs;
}

function current_language(array $langs): string {
    return $langs[0];
}

function language_list_length(array $langs): int {
    return count($langs);
}