<?php
declare(strict_types=1);

function brackets_match(string $input): bool
{
    $BRACKET_PAIRS = [
        '{' => '}',
        '[' => ']',
        '(' => ')',
    ];

    $seen = []; # keep track of what brackets need to be closed
    for ($i=0; $i < strlen($input); $i++) { 
        $char = $input[$i];
        
        # remember openings
        if (array_key_exists($char, $BRACKET_PAIRS)) {
            $seen[] = $BRACKET_PAIRS[$char];
            continue;
        }

        # ignore everything that isn't a closing bracket
        if (!in_array($char, $BRACKET_PAIRS)) 
            continue;
        
        # check if it matches the last opened (if any)
        if (array_pop($seen) !== $char)
            # Houston, we have a problem
            return false; 
    }
    
    return empty($seen);
}
