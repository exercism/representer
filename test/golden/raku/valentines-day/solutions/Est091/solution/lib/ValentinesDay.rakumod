unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean', 'Turkish');
enum   Movie       is export ('Crime', 'Horror', 'Romance');
enum   Game        is export ('Chess', 'TicTacToe', 'GlobalThermonuclearWar');
subset Walk of Num is export where 0 < * < Inf;

subset Activity is export where * ~~ any(Chill, Restaurant, Movie, Game, Walk);

multi rate-activity ( Chill --> Answer ) is export {
    return No
}

multi rate-activity ( Restaurant $cuisine --> Answer ) is export {
    return Yes if $cuisine eq "Korean";
    return Answer;
}

multi rate-activity ( Movie $genre --> Answer ) is export {
    return Yes if $genre eq "Romance";
    return No;
}

multi rate-activity ( Game $name --> Answer ) is export {
    return Yes if $name eq "Chess";
    return Answer if $name eq "TicTacToe";
    return No;
}

multi rate-activity ( Walk $length --> Answer ) is export {
    return Yes if $length < 1;
    return Answer if $length < 15;
    return No;
}