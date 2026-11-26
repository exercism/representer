<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

function encode(string $input): string
{
    $input_length = strlen($input);
    $compressed_input = '';
    $consecutive_char_count = 1;
    
    for ($i = 0; $i < $input_length; $i++) {
        $current_character = substr($input, $i, 1);
        $next_character = substr($input, $i+1, 1);
        if ($current_character === $next_character) {
            $consecutive_char_count++;
        } else {
            if($consecutive_char_count !== 1) {
                $compressed_input .= $current_character;
            } else {
                $compressed_input .= $consecutive_char_count . $current_character;
                $consecutive_char_count = 1;
            }
        }
    }
    return $compressed_input;
}

function decode(string $input): string
{
    $input_length = strlen($input);
    $uncompressed_input = '';
    // Regex to check if this is a digit
    $re = '/\d/';
    $characters_multiplier = 0;

    for($i = 0; $i < $input_length; $i++) {
        $current_character = substr($input, $i, 1);
        $next_character = substr($input, $i+1, 1);
  
        if (preg_match($re,$current_character) === 0){
            if($characters_multiplier > 0) {
                $uncompressed_input .= str_repeat($current_character, (int) $characters_multiplier);
                $characters_multiplier = 0;
            } else {
                $uncompressed_input .= $current_character;
            }
        } else {
            $characters_multiplier .= $current_character;
        }
    }
    return $uncompressed_input;
}
