unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean', 'Turkish');
enum   Movie       is export ('Crime', 'Horror', 'Romance');
enum   Game        is export ('Chess', 'TicTacToe', 'GlobalThermonuclearWar');
subset Walk of Num is export where {$_ > 0 and $_ < Inf}

subset Activity is export where * ~~ any(Chill, Restaurant, Movie, Game, Walk);

multi rate-activity ( Chill --> Answer ) is export { No }

multi rate-activity ( Restaurant $cuisine --> Answer ) is export { 
    return Yes if $cuisine eq 'Korean';
    Answer
}
multi rate-activity ( Movie $genre --> Answer ) is export { 
    return Yes if $genre eq 'Romance';
    No
}
multi rate-activity ( Game $gametype --> Answer ) is export { 
    return Yes if $gametype eq 'Chess';
    return No if $gametype eq 'GlobalThermonuclearWar';
    Answer
}
multi rate-activity ( Walk $duration --> Answer ) is export { 
    return Yes if $duration < 1;
    return No if $duration >= 15;
    Answer
}