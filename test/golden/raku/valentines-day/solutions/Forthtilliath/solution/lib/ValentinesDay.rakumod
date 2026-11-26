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
    return No;
}

multi rate-activity ( Restaurant $type --> Answer ) is export {
    return Yes if $type eq 'Korean';
    return No;
}

multi rate-activity ( Movie $type --> Answer ) is export {
    return Yes if $type eq 'Romance';
    return No;
}

multi rate-activity ( Game $type --> Answer ) is export {
    return Yes if $type eq 'Chess';
    return No if $type eq 'GlobalThermonuclearWar';
    return Answer;
}

multi rate-activity ( Walk $n --> Answer ) is export {
    return Yes if $n eq 0.5;
    return No if $n eq 15;
    return No;
}
