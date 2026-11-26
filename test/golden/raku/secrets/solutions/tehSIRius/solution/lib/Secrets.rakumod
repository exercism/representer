unit module Secrets;

sub secret-add ($secret --> Code) is export {
    return -> $additional-argument { $additional-argument + $secret };
}

sub secret-subtract ($secret --> Code) is export {
    return -> $additional-argument { $additional-argument - $secret; };
}

sub secret-multiply ($secret --> Code) is export {
    return -> $additional-argument { $additional-argument * $secret; };
}

sub secret-divide ($secret --> Code) is export {
    return -> $additional-argument { $additional-argument / $secret; };
}

sub secret-combine ($func1, $func2 --> Code) is export {
    return -> $additional-argument { $func2($func1($additional-argument)); };
}
