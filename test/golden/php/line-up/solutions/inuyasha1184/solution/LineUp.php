<?php
declare(strict_types=1);

function format(string $name, int $number): string
{   
    $output = match($number % 100) {
        11, 12, 13 => 'th',
        default => match($number % 10) {
            1 => 'st',
            2 => 'nd',
            3 => 'rd',
            default => 'th'
        }
    };
    return "$name, you are the $number$output customer we serve today. Thank you!";
}
