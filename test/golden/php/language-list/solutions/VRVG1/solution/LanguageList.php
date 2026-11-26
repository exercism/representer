<?php

function language_list(...$lenguajes)
{
    return $lenguajes;
}

function add_to_language_list($lenguajes, $nuevo_lenguaje) {
    $lenguajes[] = $nuevo_lenguaje;
    return $lenguajes;
}

function prune_language_list($lenguajes) {
    array_shift($lenguajes);
    return $lenguajes;
}

function current_language($lenguajes) {
    return $lenguajes[0];
}

function language_list_length($lenguajes) {
    return count($lenguajes);
}