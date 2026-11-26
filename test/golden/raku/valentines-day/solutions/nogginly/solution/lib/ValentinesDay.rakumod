unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean', 'Turkish');
enum   Movie       is export ('Crime', 'Horror', 'Romance');
enum   Game        is export ('Chess', 'TicTacToe', 'GlobalThermonuclearWar');

subset Positive of Num is export where * > 0;
subset Walk of Positive is export where * < Inf;

subset Activity is export where * ~~ any(Chill,Restaurant, Movie, Game, Walk);

multi rate-activity ( Chill --> Answer ) is export {
    return No
}

multi rate-activity ( Restaurant $cuisine --> Answer ) is export {
    if $cuisine == ::('Korean') {
        return Yes
    }
    return No
}

multi rate-activity ( Movie $m --> Answer ) is export {
    if $m == ::('Romance') {
        return Yes
    }
    return No
}

multi rate-activity ( Game $g --> Answer ) is export {
    if $g == ::('Chess') {
        return Yes
    }
    return No
}

multi rate-activity ( Walk $w --> Answer ) is export {
    if $w == 0.5 {
        return Yes
    }
    return No
}
