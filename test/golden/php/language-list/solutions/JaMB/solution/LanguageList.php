<?php

function language_list(...$a) {
    return $a;
}

function add_to_language_list($arr, $x) {
    $ret = [];
    foreach($arr as $it) {
        $ret[] = $it;
    }
    $ret[] = $x;
    return $ret;
}

function prune_language_list($arr) {
    $ret = [];
    $first = true;
    foreach($arr as $it) {
        if(!$first) {
            $ret[] = $it;
        }
        $first = false;
    }
    return $ret;
}

function current_language($arr) {
    return $arr[0];
}

function language_list_length($arr) {
    return count($arr);
}