unit module Secrets;

sub secret-add ($secret --> Code) is export {
    return -> $x { $x + $secret}
}

sub secret-subtract ($secret --> Code) is export {
    return -> $x {$x - $secret}
}

sub secret-multiply ($secret --> Code) is export {
    return -> $x { $x * $secret }
}

sub secret-divide ($secret --> Code) is export {
    return -> $x { $x / $secret}
}

sub secret-combine ($f1, $f2 --> Code) is export {
    return -> $x { $f2($f1($x))}
}
